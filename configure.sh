#configure.sh VNC_USER_PASSWORD VNC_PASSWORD TS_KEY


echo "--- VM Info ---"
sw_vers
sysctl -n machdep.cpu.brand_string hw.memsize
system_profiler SPHardwareDataType SPSoftwareDataType
echo "---------------"

echo "Turning Spotling Index OFF"
nohup bash -c '
# Disable indexing volumes
sudo defaults write ~/.Spotlight-V100/VolumeConfiguration.plist Exclusions -array "/Volumes" || true
sudo defaults write ~/.Spotlight-V100/VolumeConfiguration.plist Exclusions -array "/Network" || true
sudo killall mds || true
sleep 60
sudo mdutil -a -i off / || true
sudo mdutil -a -i off || true
sudo launchctl unload -w /System/Library/LaunchDaemons/com.apple.metadata.mds.plist || true
sudo rm -rf /.Spotlight-V100/*
rm -rf ~/Library/Metadata/CoreSpotlight/ || true
killall -KILL Spotlight spotlightd mds || true
sudo rm -rf /System/Volums/Data/.Spotlight-V100 || true
brew install --cask keka
' >/dev/null 2>&1 &

echo "Creating User"
#Create new account
sudo dscl . -create /Users/vncuser
sudo dscl . -create /Users/vncuser UserShell /bin/bash
sudo dscl . -create /Users/vncuser RealName "User"
sudo dscl . -create /Users/vncuser UniqueID 1001
sudo dscl . -create /Users/vncuser PrimaryGroupID 80
sudo dscl . -create /Users/vncuser NFSHomeDirectory /Users/vncuser
sudo dscl . -passwd /Users/vncuser $1
sudo dscl . -passwd /Users/vncuser $1
sudo createhomedir -c -u vncuser > /dev/null

echo "🕵️ Check SIP Status..."
csrutil status
echo "🔓 SIP is disabled! Injecting permissions into TCC.db..."
# 使用 Python 腳本來處理 SQLite，比較不會因為欄位變動而炸裂
sudo python3 -c "
import sqlite3
import time
import os

# TCC 資料庫路徑
db_path = '/Library/Application Support/com.apple.TCC/TCC.db'

if not os.path.exists(db_path):
    print(f'❌ Error: DB not found at {db_path}')
    exit(1)

try:
    con = sqlite3.connect(db_path)
    cur = con.cursor()

    # 定義我們要授權的服務
    # 1. kTCCServiceScreenCapture: 允許看畫面
    # 2. kTCCServicePostEvent: 允許控制滑鼠鍵盤
    # 3. kTCCServiceAccessibility: 輔助使用權限 (有時候需要)
    services = [
        'kTCCServiceScreenCapture', 
        'kTCCServicePostEvent',
        'kTCCServiceAccessibility'
    ]
    
    # 目標程式：macOS 內建螢幕分享代理程式
    client = 'com.apple.screensharing.agent'
    
    # 獲取當前時間戳
    now = int(time.time())

    # 針對每個服務進行注入
    for service in services:
        print(f'💉 Injecting {service} for {client}...')
        
        # 這是 macOS 12+ (含 Sequoia) 常見的 TCC 表結構插入
        # 使用 INSERT OR REPLACE 覆蓋舊設定
        # auth_value=2 代表 'Allowed'
        cur.execute('''
            INSERT OR REPLACE INTO access 
            (service, client, client_type, auth_value, auth_reason, auth_version, csreq, policy_id, indirect_object_identifier_type, indirect_object_identifier, flags, last_modified)
            VALUES (?, ?, 0, 2, 4, 1, NULL, NULL, 0, 'UNUSED', 0, ?)
        ''', (service, client, now))
        
    con.commit()
    print('TCC Permissions injected successfully.')
    con.close()

except Exception as e:
    print(f'❌ TCC Injection Failed: {e}')
    # 如果是因為欄位數量不對 (macOS 版本差異)，這裡會報錯，但通常 macOS 15 結構如上
    exit(1)
"

# --- 接下來接你原本的 Kickstart 重啟指令 ---

echo "🔄 Restarting Remote Management to apply TCC changes..."
VNC_PWD="$VNC_PASSWORD"

sudo defaults write /Library/Preferences/com.apple.universalaccess reduceTransparency -bool true
sudo defaults write /Library/Preferences/com.apple.universalaccess reduceMotion -bool true
killall Dock
sudo defaults write com.apple.finder ShowExternalHardDrivesOnDesktop -bool false
sudo defaults write com.apple.finder ShowRemovableMediaOnDesktop -bool false
sudo defaults write com.apple.finder ShowMountedServersOnDesktop -bool false
killall Finder
sudo ln -s / ~/Desktop/Macintosh\ HD
sudo ln -s ~ ~/Desktop/Home
sudo ln -s / /Users/vncuser/Desktop/Macintosh\ HD
sudo ln -s /Users/vncuser /Users/vncuser/Desktop/Home

sudo launchctl asuser $(id -u vncuser) \
defaults write -g AppleLanguages -array "zh-Hant-TW" "en-US"

sudo touch /var/db/.AppleSetupDone
sudo chmod 644 /var/db/.AppleSetupDone
sudo chown root:wheel /var/db/.AppleSetupDone

open -a Terminal && sleep 1 && osascript -e 'tell application "Terminal" to quit'
osascript -e 'tell application "System Events" to tell appearance preferences to set dark mode to true'
open /System/Library/PreferencePanes/Displays.prefPane

# 1. 停止服務
sudo /System/Library/CoreServices/RemoteManagement/ARDAgent.app/Contents/Resources/kickstart -deactivate -configure -access -off
sleep 1

# 2. 重新啟動 (現在它應該已經有權限了)
sudo /System/Library/CoreServices/RemoteManagement/ARDAgent.app/Contents/Resources/kickstart \
  -activate -configure -access -on \
  -clientopts -setvnclegacy -vnclegacy yes \
  -clientopts -setvncpw -vncpw "$VNC_PWD" \
  -restart -agent -privs -all -allowAccessFor -allUsers

# 3. 確保使用者也在群組裡
sudo dseditgroup -o edit -a "$(whoami)" -t user com.apple.access_screensharing

echo "🚀 Ready to connect!"
echo "🖥️ Screen Sharing enabled."
echo "使用螢幕共享時，帳號 [vncuser] || Apple Screen Sharing User [vncuser]"


#VNC password - http://hints.macworld.com/article.php?story=20071103011608872
echo $2 | perl -we 'BEGIN { @k = unpack "C*", pack "H*", "1734516E8BA8C5E2FF1C39567390ADCA"}; $_ = <>; chomp; s/^(.{8}).*/$1/; @p = unpack "C*", $_; foreach (@k) { printf "%02X", $_ ^ (shift @p || 0) }; print "\n"' | sudo tee /Library/Preferences/com.apple.VNCSettings.txt

#Start VNC/reset changes
sudo /System/Library/CoreServices/RemoteManagement/ARDAgent.app/Contents/Resources/kickstart -restart -agent -console
sudo /System/Library/CoreServices/RemoteManagement/ARDAgent.app/Contents/Resources/kickstart -activate

brew install tailscale
sudo brew services start tailscale
# 5. 讓子彈飛一會兒 (等待 Daemon 建立 Socket)echo "⏳ 等待 Tailscale 服務啟動中..."

# 6. 登入並配置# --ssh: 順便開啟 Tailscale SSH 功能，以後 SSH 更方便# --accept-routes: 如你有設 Subnet Router 這很有用
sudo tailscale up --authkey "$TS_KEY"
echo "--- VM IP ----"
tailscale ip
echo "----- VNC ----"
echo "User: vncuser"
echo "Password: Your VNC_USER_PASSWORD"
echo "--------------"
echo "Installing noVNC..."
pip install websockify
cd ~
git clone https://github.com/iambjlu/noVNC.git
cd ~/noVNC;nohup websockify --web . --cert self.crt --key self.key 6080 localhost:5900 >/dev/null 2>&1 &
echo "--- VM IP ----"
tailscale ip
echo "----- VNC ----"
echo "User: vncuser"
echo "Password: Your VNC_USER_PASSWORD"
echo "--- noVNC ---"
echo "https://$(tailscale ip -4):6080/vnc.html"
echo "-------------"

# 7. 開啟 Funnel
sudo tailscale funnel 8080
