# MacOS-Workflow-VNC
戳幾下就得到一個免費可用的VNC連線的macOS遠端桌面(且已安裝Xcode)、RDP連線的Windows、code-server的Ubuntu<br>
Get a macOS desktop (with Xcode), Windows RDP, Ubuntu code-server over VNC, for free, in several clicks

> 由於系統改版，所以大幅修改腳本使其可以使用，實測macOS 15、macOS 26可以用<br>
> 基於原作者的說明，增加中文說明與圖解<br>

### [影片示範](https://www.youtube.com/watch?v=kCA-j-A6Iic)


<br>
    
<hr />

### 1
[在此頁面按下fork](https://github.com/iambjlu/MacOS-Workflow-VNC/fork)<br>
[On this page click fork](https://github.com/iambjlu/MacOS-Workflow-VNC/fork)<br>

<br>
<hr />

### 2
拿一個Tailscale Key<br>
Get Tailscale Key<br>
[https://login.tailscale.com/admin/settings/keys](https://login.tailscale.com/admin/settings/keys)<br>

<img width="1149" height="719" alt="image" src="https://github.com/user-attachments/assets/af2d550b-fd59-4259-9a5b-e440150b167a" />


<hr />

### 3

* 新增三個Secrets到forked的儲存庫
  * 剛拿到的Tailscale Auth Key存在`TS_KEY`
  * 想一個使用者密碼存到`VNC_USER_PASSWORD`
  * 想一個密碼存到`VNC_PASSWORD` (建議跟上面一樣)

* Add three secrets to your cloned repo: 
  * `TS_KEY` with your auth Tailscale Auth key
  * `VNC_USER_PASSWORD` with the desired password for the "VNC User" (`vncuser`) account

<img width="1111" height="771" alt="image" src="https://github.com/user-attachments/assets/b5491821-d0fb-4dc5-9672-2ed704bc34df" />

  
<hr />

### 4

* 去[Actions頁面](https://github.com/iambjlu/MacOS-Workflow-VNC/actions)，在側邊欄選擇版本和Runner大小即可開始使用 (沒寫版本就是最新穩定版)
* Start the workflow by choose version and Runner size on sidebar of [Actions page](https://github.com/iambjlu/MacOS-Workflow-VNC/actions) (no version label means latest stable version)

[Runner size : large and x-large?](https://docs.github.com/en/enterprise-cloud@latest/actions/how-tos/manage-runners/larger-runners/use-larger-runners?platform=mac#available-macos-larger-runners)

  
<hr />


### 5

* 機器IP會印在Console (在自己電腦上也要打開Tailscale才能連)
* VM IP will be printed in console (Remember to tailscale up on your own Mac/PC)

<img width="842" height="345" alt="image" src="https://github.com/user-attachments/assets/22058cbb-e46b-474a-bff8-30b63aaa0366" />


### macOS執行個體 macOS Instance
<pre>
對於Mac使用者，使用「螢幕共享」(內建的)連線
For macOS user, use Screen Sharing to connect

對於Windows使用者，使用VNC Viewer連線
For Windows user, use VNC Viewer to connect
    
不建議使用檔案保險箱，這可能會拖累效能
Enabling FileVault is not recommended

如果任何應用程式需要管理員權限，使用vncuser帳號(和先前建立的密碼)登入
If sudo needed, login as vncuser (and its password)

*Mac (特別是macOS 14)的效能相對良好，也很適合使用JetBrains Toolbox或是VS Code進行SSH連入遠端開發
</pre>

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
<hr />


### 6

* 用完後可以關掉使用的機器
* Turn off VM after use
  
<img width="703" height="518" alt="image" src="https://github.com/user-attachments/assets/f5690c36-26f4-4caa-a906-6ead2b4c8902" />


<hr/><br>


## Benchmark Assessment 效能評估

Geekbench 6<br>
<img width="1039" height="534" alt="image" src="https://github.com/user-attachments/assets/3365d258-aec7-49a7-b231-66568873555e" />



[Xcode Benchmark 16~26 Compatible Version](https://github.com/devMEremenko/XcodeBenchmark/tree/e3210b662a33b3041ee8ccb079b82a988cec21ba)
<br>
<img width="1177" height="1027" alt="image" src="https://github.com/user-attachments/assets/fa22eb8f-dd89-4355-8bd3-90d176c1e9d1" />


<hr />

### 進階用法 Advanced:<br>
如果需要更換macOS版本，在Actions頁面切換不同yml即可<br>
或至yml檔案更換為Github支援的image<br>
If you need different macOS Version, choose different yml or change yml with Github suported image

[https://github.com/actions/runner-images/tree/main?tab=readme-ov-file#available-images](https://github.com/actions/runner-images/tree/main?tab=readme-ov-file#available-images)

