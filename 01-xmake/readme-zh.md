[English Readme](./readme.md)

# 项目结构
```
├── application
│   ├── src
│   └── xmake.lua
├── core
│   ├── src
│   └── xmake.lua
├── engine
│   ├── src
│   └── xmake.lua
├── framework
│   ├── src
│   └── xmake.lua
├── readme.md
└── xmake.lua
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

# 编译发布

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