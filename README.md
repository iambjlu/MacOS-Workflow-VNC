# MacOS-Workflow-VNC
戳幾下就得到一個免費可用的VNC連線的macOS遠端桌面(且已安裝Xcode)、RDP連線的Windows、code-server的Ubuntu<br>
Get a macOS desktop (with Xcode), Windows RDP, Ubuntu code-server over VNC, for free, in several clicks

> 由於系統改版，所以大幅修改腳本使其可以使用，實測macOS 15、macOS 26可以用<br>
> 基於原作者的說明，增加中文說明與圖解<br>

### [影片示範](https://www.youtube.com/watch?v=kCA-j-A6Iic)


<img width="1159" height="852" alt="image" src="https://github.com/user-attachments/assets/2bec4e93-6a8e-421b-8419-e4a5c92b655c" />

<br>
    
<hr />

### 1
在此頁面按下fork<br>
On this page click fork<br>
<img width="557" height="147" alt="image" src="https://github.com/user-attachments/assets/9f8b71f3-3162-4ab7-8abb-71e8362ab212" />
<br>
<hr />

### 2
拿一個Tailscale Key<br>
Get Tailscale Key<br>
[https://login.tailscale.com/admin/settings/keys](https://login.tailscale.com/admin/settings/keys)<br>

  <img width="1031" height="809" alt="image" src="https://github.com/user-attachments/assets/ef7f9313-40f3-45db-984f-2b9e03c7637e" />

<hr />

### 3

* 新增三個Secrets到forked的儲存庫
  * 剛拿到的Tailscale Key存在`TS_KEY`
  * 想一個使用者密碼存到`VNC_USER_PASSWORD`
  * 想一個密碼存到`VNC_PASSWORD` (建議跟上面一樣)

* Add three secrets to your cloned repo: 
  * `TS_KEY` with your auth Tailscale key
  * `VNC_USER_PASSWORD` with the desired password for the "VNC User" (`vncuser`) account
  * `VNC_PASSWORD` for the VNC-only password
 
 <img width="1017" height="836" alt="image" src="https://github.com/user-attachments/assets/ab3e086d-44c1-4746-ba1f-402053456016" />
  
<hr />

### 4

* 去Actions頁面，在側邊欄選擇版本和Runner大小即可開始使用 (沒寫版本就是最新穩定版)
* Start the workflow by choose version and Runner size on sidebar of Actions page(no version label means latest stable version)

[Runner size : large and x-large?](https://docs.github.com/en/enterprise-cloud@latest/actions/how-tos/manage-runners/larger-runners/use-larger-runners?platform=mac#available-macos-larger-runners)

<img width="1656" height="874" alt="image" src="https://github.com/user-attachments/assets/c20db27b-590e-42c0-8a67-9dac21ca2fdf" />


  
<hr />


### 5

* 機器IP會印在Console (在自己電腦上也要打開Tailscale才能連)
* VM IP will be printed in console (Remember to tailscale up on your own Mac/PC)

<img width="263" height="125" alt="image" src="https://github.com/user-attachments/assets/55f73e90-19ea-4664-a783-11b1f0353610" />

### macOS執行個體 macOS Instance
對於Mac使用者，使用「螢幕共享」(內建的)連線<br>
For macOS user, use Screen Sharing to connect<br>

對於Windows使用者，使用VNC Viewer連線<br>
For Windows user, use VNC Viewer to connect<br>

不建議使用檔案保險箱，這可能會拖累效能<br>
Enabling FileVault is not recommended<br>

如果任何應用程式需要管理員權限，使用vncuser帳號(和先前建立的密碼)登入<br>
If sudo needed, login as vncuser (and its password)<br>

<img width="2196" height="1612" alt="image" src="https://github.com/user-attachments/assets/44b21683-ab38-42ff-8043-b39abd61a059" />
<img width="1910" height="1334" alt="image" src="https://github.com/user-attachments/assets/148ecfe6-9cb8-4375-9f1c-9b392cd29736" />

### Windows執行個體 Windows Instance
<pre>
    使用遠端桌面連線連接終端機印出的帳號密碼
    Use RDP to connect, account and password is printed in console
</pre>

### Linux執行個體 Linux Instance
<pre>
    使用ssh連接終端機印出的帳號，不需密碼
    Use ssh to connect, account is printed in console, no password needed

    使用終端機印出的code-server網址，可以使用網頁版Code，密碼是先前儲存的VNC_USER_PASSWORD
    Use url in console to connect code-server, password is your VNC_USER_PASSWORD
</pre>

<br>
<br>
如果有架設服務，Funnel也開好 8080 Port了，可以直接用<br>
Funnel on 8080 port is also enabled<br>
<img width="453" height="107" alt="image" src="https://github.com/user-attachments/assets/57bb830a-3e2e-477c-8299-69ce43e0bcc7" />

  
<hr />


### 6

* 用完後可以關掉使用的機器
* Turn off VM after use
 <img width="782" height="471" alt="image" src="https://github.com/user-attachments/assets/9dfe4acd-77f9-400f-b829-2232490e43c3" />



<hr/><br>


## Benchmark Assessment 效能評估

Geekbench 6<br>
<img width="856" height="276" alt="image" src="https://github.com/user-attachments/assets/ab18a2fa-7d13-461b-831a-67758925b8a9" />


[Xcode Benchmark 16~26 Compatible Version](https://github.com/devMEremenko/XcodeBenchmark/tree/e3210b662a33b3041ee8ccb079b82a988cec21ba)
<br>

<img width="1621" height="942" alt="image" src="https://github.com/user-attachments/assets/03186816-922f-4f12-868d-0ec01ad66aa2" />

[Xcode Benchmark 15 Compatible Version](https://github.com/devMEremenko/XcodeBenchmark/tree/ba4d2f631b9c159b1d69a57b3ccf9754e54738bb)
<br>
The score is only using to compare to other Xcode 15 Benchmark
<br>

<img width="591" height="462" alt="image" src="https://github.com/user-attachments/assets/554700c4-22dc-40b4-8208-6cdeddb06aa6" />

<hr />

### 進階用法 Advanced:<br>
如果需要更換macOS版本，在Actions頁面切換不同yml即可<br>
或至此檔案更換為Github支援的image<br>
If you need different macOS Version, choose different yml or change it here in yml with Github suported image

[https://github.com/actions/runner-images/tree/main?tab=readme-ov-file#available-images](https://github.com/actions/runner-images/tree/main?tab=readme-ov-file#available-images)
<img width="1018" height="647" alt="image" src="https://github.com/user-attachments/assets/968b3fc9-0bf2-48ef-adf6-be32fce48630" />
