local target_name = "framework"

-- OS detection function
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
local platform_dir = src_dir .. "/platform/" .. osname
local shared_dir = src_dir .. "/share"

-- Set up external dependencies
local packages = {
    {name = "gtest"},
}



for _, pkg in ipairs(packages) do
    print("Adding package '" .. pkg.name .. "'")
    if pkg.branch then
        add_requires(pkg.name .. " " .. pkg.branch, {alias = pkg.name})
    else
        add_requires(pkg.name, {alias = pkg.name})
    end
end


local function common_target_config()
    add_includedirs("include",  {public = true})
    add_files(shared_dir .. "**.c", shared_dir .. "**.cpp")
    add_files(platform_dir .. "**.cpp")
    for _, pkg in ipairs(packages) do
        add_packages(pkg.name, {public = true})
    end
    on_load(function (target)
    for _, pkg in ipairs(packages) do
        local package = target:pkg(pkg.name)
        print("Checking package '" .. pkg.name .. "'")
        if package then
            local dir = package:installdir()
            if dir then
                print("Found include directory for '" .. pkg.name .. "' at '" .. path.join(dir, "include") .. "'")
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

add_rules("mode.debug", "mode.release")

-- Set the target
target(target_name)
    if is_mode("debug") then
        set_kind("shared")
    elseif is_mode("release") then
        set_kind("static") 
    end
    set_languages("cxx20")
    common_target_config()

    -- Add source files
    add_files("src/*.cpp")
    add_files("src/**/*.cpp")  -- Recursively add all .cpp files in subdirectories
    
    -- Add include directories
    add_deps("core", {public = true})
    add_includedirs("../core/include")

    -- Set the output directory
    set_targetdir("$(buildir)/lib/$(plat)/$(arch)/$(mode)")


    -- Platform-specific configurations
    if is_plat("windows") then
        add_cxflags("/W4")  -- Enable high warning level on Windows
        if is_mode("debug") then
            add_cxflags("/Od", "/Zi")  -- Disable optimization, enable debugging info
        else
            add_cxflags("/O2")  -- Enable full optimization
        end
    elseif is_plat("linux", "macosx") then
        add_cxflags("-Wall", "-Wextra", "-pedantic", "-Wno-gnu-line-marker")  -- Enable high warning level on Unix-like systems
        if is_mode("debug") then
            add_cxflags("-O0", "-g")  -- Disable optimization, enable debugging info
        else
            add_cxflags("-O3")  -- Enable full optimization
        end
    end

    -- Custom build configurations
    if is_mode("debug") then
        add_defines("DEBUG")
    elseif is_mode("release") then
        add_defines("NDEBUG")
        set_optimize("fastest")
    end



target(target_name .. "_test")
    set_kind("binary")
    set_languages("cxx20")
    common_target_config()
    add_files("tests/**.cpp")  -- Add test files
    add_packages("gtest")  -- Link with gtest
    add_deps(target_name)  -- Add dependency on the core library
    set_targetdir("$(buildir)/bin/$(plat)/$(arch)/$(mode)")