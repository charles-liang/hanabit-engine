local project_name = "application"

set_project(project_name)
set_version("1.0.0")
set_languages("cxx20")

add_rules("mode.debug", "mode.release")

local build_dir = "build"
local third_party_dir = "third_party"

local function get_os_name()
    if is_plat("windows") then
        return "windows"
    elseif is_plat("macosx") then
        return "macosx"
    elseif is_plat("iphoneos") then
        return "iphoneos"
    elseif is_plat("android") then
        return "android"
    elseif is_plat("unix", "linux") then
        return "unix"
    elseif is_plat("wasm") then
        return "wasm"
    end
    return ""
end



local osname = get_os_name()
local src_dir = "src"
-- 设置外部依赖项
local packages = {
    {name = "gtest"},
}

for _, pkg in ipairs(packages) do
    print("Adding package '" .. pkg.name .. "'")
    if pkg.branch then
        add_requires(pkg.name .. " ".. pkg.branch, {alias = pkg.name})
    else
        add_requires(pkg.name, {alias = pkg.name})
    end
end


local function common_target_config()
    add_includedirs("include")
    add_files(src_dir .. "/**.cpp")
    for _, pkg in ipairs(packages) do
        add_packages(pkg.name)
    end
    on_load(function (target)
    for _, pkg in ipairs(packages) do
        local package = target:pkg(pkg.name)
        print("Checking package '" .. pkg.name .. "'")
        if package then
            local dir = package:installdir()
            if dir then
                print("Found package '" .. pkg.name .. "' at '" .. dir .. "'")
                target:add("includedirs", path.join(dir, "include"))
                target:add("linkdirs", path.join(dir, "lib"))
                
                -- 根据构建模式选择链接库
                local links_to_add = nil
                pkg.links = pkg.links or {debug = "", release = ""}
                if is_mode("debug") then
                    links_to_add = pkg.links.debug or pkg.links.release
                else
                    links_to_add = pkg.links.release
                end
                
                if links_to_add then
                    for _, link in ipairs(string.split(links_to_add, " ")) do
                        target:add("links", link)
                    end
                end
            else
                print("Warning: Install directory for '" .. pkg.name .. "' not found.")
            end
        else
            print("Warning: Package '" .. pkg.name .. "' not found.")
        end
        end
    end)
end

-- 主目标配置
target(project_name)
    set_kind("binary")
    add_includedirs("include")
    add_includedirs("../core/include")
    add_includedirs("../framework/include")
    add_includedirs("../engine/include")
    add_deps("core")
    add_deps("framework")
    add_deps("engine")

    common_target_config()

if is_plat("macosx", "iphoneos") then
    add_rules("xcode.application")
end

if is_plat("windows") then
    add_cxxfags("-mwindows -municode", {force = true})
    add_ldflags("-lstdc++ -lm", {force = true})
    if is_mode("debug") then
        set_symbols("debug")
        set_optimize("none")
        add_ldflags("/SUBSYSTEM:CONSOLE", {force = true})
    else
        add_ldflags("/SUBSYSTEM:WINDOWS", {force = true})
    end
end

-- 测试目标配置
target("tests")
    set_kind("binary")
    add_files("tests/*.cpp")
    add_deps(project_name)
    common_target_config()
