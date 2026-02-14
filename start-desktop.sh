#!/bin/bash

export HOME=/home/runner
export DISPLAY=:1
export USER=runner

NOVNC_DIR=$(dirname $(which novnc))/../share/webapps/novnc
WEBROOT=/tmp/novnc-web

mkdir -p $HOME/.vnc
mkdir -p $HOME/.fluxbox
mkdir -p $WEBROOT

cp -r $NOVNC_DIR/* $WEBROOT/
cat > $WEBROOT/index.html << 'INDEXEOF'
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="refresh" content="0;url=vnc.html?autoconnect=true&resize=scale">
</head>
<body>
<p>Connecting to desktop...</p>
</body>
</html>
INDEXEOF

cat > $HOME/.fluxbox/startup << 'FLUXEOF'
#!/bin/bash
xsetroot -solid "#2c3e50" &
xterm &
exec fluxbox
FLUXEOF
chmod +x $HOME/.fluxbox/startup

cat > $HOME/.fluxbox/menu << 'MENUEOF'
[begin] (Desktop)
  [exec] (Terminal) {xterm}
  [submenu] (System)
    [restart] (Restart Fluxbox)
    [exit] (Exit Fluxbox)
  [end]
[end]
MENUEOF

rm -f /tmp/.X1-lock /tmp/.X11-unix/X1 2>/dev/null

Xvnc :1 \
  -localhost 0 \
  -SecurityTypes None \
  -geometry 1280x720 \
  -depth 24 &

sleep 2

fluxbox &
xsetroot -solid "#2c3e50" &
xterm &

sleep 1

# Устанавливаем websockify, если его нет
if ! command -v websockify &> /dev/null; then
    sudo apt install -y websockify
fi

# ... после запуска Xvnc и fluxbox ...

sleep 1

# Запуск noVNC через websockify
websockify --web $WEBROOT 5000 localhost:5901
