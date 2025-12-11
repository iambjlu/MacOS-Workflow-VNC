#configure.sh VNC_USER_PASSWORD VNC_PASSWORD TS_KEY
echo "--- VM Info ---"
echo "== 系統資訊 System Info =================="
uname -a

echo "== CPU 資訊 CPU Info ===================="
lscpu

echo "== 記憶體資訊 RAM Info ==================="
cat /proc/meminfo | grep -E "MemTotal|MemFree|MemAvailable"
free -h

echo "== 磁碟資訊 Disk Info ==================="
lsblk
df -h

echo "== GPU / 顯示卡 GPU/Display============="
lspci | grep -i vga

echo "== 作業系統版本 OS Info ================"
cat /etc/os-release

echo "== 開機時間與系統運行時間 OS Boot time =="
uptime

echo "== 網路介面 Network Interface ========"
ip a | grep -E "^[0-9]+:|inet "

echo "== 主機名稱 Host name ================"
hostname

echo "== 處理器資訊（詳細）CPU Info =========="
cat /proc/cpuinfo | grep -E "model name|cpu MHz|cache size" | uniq
echo "---------------"


sudo hostnamectl set-hostname "ubuntu-$(hostname)"
sudo apt update
sudo apt install unzip

echo "安裝Tailscale..."
bash -c 'curl -fsSL https://tailscale.com/install.sh | sh'
echo "🚀 啟動 Tailscale service..."
sudo systemctl enable --now tailscaled
echo "⏳ 等待 Tailscale 服務啟動中..."
sudo tailscale up --authkey "$TS_KEY" --ssh
echo "---------"
echo "✅ 建立完成"
echo "使用者名稱Username: runner"
echo "Tailscale IP: $(tailscale ip -4)"
echo "SSH 連線指令: ssh runner@$(tailscale ip -4)"
echo "---------"
echo "💻 安裝 code-server..."
bash -c '
curl -fsSL https://code-server.dev/install.sh | sh
mkdir -p "$HOME/.certs"
cd "$HOME/.certs"
openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
  -keyout code-server.key \
  -out code-server.crt \
  -subj "/C=TW/ST=Taiwan/L=Taipei/O=Dev/OU=Dev/CN=code-server"'
echo "⚙️ 寫入 code-server 設定..."
mkdir -p "$HOME/.config/code-server"
cat > "$HOME/.config/code-server/config.yaml" <<EOF
bind-addr: 0.0.0.0:8181
cert: $HOME/.certs/code-server.crt
cert-key: $HOME/.certs/code-server.key
auth: password
password: $1
EOF
rm -rf "$HOME/.cache"
echo "🚀 啟動 code-server..."

echo "---------"
echo "✅ 建立完成"
echo "使用者名稱Username: runner"
echo "Tailscale IP: $(tailscale ip -4)"
echo "SSH 連線指令: ssh runner@$(tailscale ip -4)"
echo "code-server: https://$(tailscale ip -4):8181/?folder=/home/runner"
echo "---------"
echo "現在時間 Now time: $(date '+%H:%M:%S') UTC"
echo "各項服務啟動中，建議2分鐘後( $(date -d '+120 seconds' '+%H:%M:%S') UTC )再嘗試連線"
echo "Suggestion: connect after 2 minutes ( $(date -d '+120 seconds' '+%H:%M:%S') UTC ) due to services still starting"
echo "---------"

nohup code-server >/dev/null 2>&1 &
sudo tailscale funnel 8080
wait
