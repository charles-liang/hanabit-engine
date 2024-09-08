[中文文档](./readme-zh.md)

# Project Structure

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

# Compile and debug run

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

# Compile release

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