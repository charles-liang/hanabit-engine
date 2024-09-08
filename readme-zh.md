[English Readme](./readme.md)

# 依赖： xmake

已经安装请直接跳过

### window 

请自行安装chocolatey，然后使用以下命令安装xmake

``` shell
choco install xmake
```

### macos


1. 请先安装xcode command line tools，

``` shell
xcode-select --install
```

2. 然后安装brew

``` shell
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

3. 安装xmake

``` shell
brew install xmake
```

# 克隆项目

``` shell
git clone https://github.com/charles-liang/hanabit-engine
```

# 项目结构

```
[x]01-xmake: 创建项目结构
```

# 切换工作目录
``` shell
cd 01-xmake
```

# 编译和调试运行

### windows
``` shell
xmake f -p windows -m debug -y
xmake
xmake run application
```

### mac os 
``` shell
xmake f -p macosx -m debug -y
xmake
xmake run application
```

### linux
``` shell
xmake f -p linux -m debug -y
xmake
xmake run application
```

# 发布

### windows
``` shell
xmake f -p windows -m release -y
xmake
xmake run application
```

### mac os 
``` shell
xmake f -p macosx -m release -y
xmake
xmake run application
```

### linux
``` shell
xmake f -p linux -m release -y
xmake
xmake run application
```