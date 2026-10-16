for f in Eclipse-C++ Eclipse-Java Kattis LiClipse PyCharm VS-Code; do
    if [ ! -f ~/Desktop/${f}.desktop ]; then
        cp /usr/share/applications/${f}.desktop ~/Desktop/
    fi
done
chmod 755 ~/Desktop/*.desktop
