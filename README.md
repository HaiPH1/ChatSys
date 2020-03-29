# Rasa UI 

### Prerequisites

[Node.js/npm](https://nodejs.org/en/) - Serves Rasa UI - Required

[Rasa](https://github.com/RasaHQ/rasa) - Phiên bản từ 1.2 trở lên, mới nhất có thể

Python: Version 3.6 trở lên

#### Cài đặt NodeJS

```sh
curl -o- https://raw.githubusercontent.com/creationix/nvm/v0.33.0/install.sh | bash

export NVM_DIR="$([ -z "${XDG_CONFIG_HOME-}" ] && printf %s "${HOME}/.nvm" || printf %s "${XDG_CONFIG_HOME}/nvm")"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" # This loads nvm

nvm install node
```

#### Clone toàn bộ mã nguồn về từ [Github](https://github.com/SamsonPh/ChatSys)

```sh
git clone https://github.com/SamsonPh/ChatSys
cd ChatSys
```

#### Cài đặt môi trường ảo python

Yêu cầu môi trường sử dụng Python 3.7.0 trở lên, tốt nhất là python 3.7.6

+ Trong trường hợp cài đặt lần đầu:
    ```sh
    sudo apt-get install python3-pip

    sudo pip3 install virtualenv

    virtualenv -p python3.7 chatsys_env
    source chatsys_env/bin/activate

    pip install -r requirement.txt

    ```
+ Trong trường hợp đã tạo môi trường python trước đó, cần kích hoạt lại vào môi trường ảo đã tạo:

    ```sh
    source chatsys_env/bin/activate

    ```


#### Cài đặt môi trường NodeJS

1. Cài đặt các gói thư viện của npm
    ```sh
    cd ChatSys/rasa-ui
    npm install
    ```
2. Cấu hình lại thông số cho Rasa Server trong package.json

    ```js
    "config": {
        "rasa_endpoint": "http://localhost:5005",
        "loglevel": "info",
        "jwtsecret": "mysecret",
        "admin_username": "admin",
        "admin_password": "admin",
        "db_schema": "3.0.1",
        "db_autoupdate": "true"
    },
    ```
    Thay host ở rasa_endpoint bằng host của máy chủ  cài đặt Rasa server nếu như Rasa server và Rasa UI được cài đặt trên 2 server khác nhau ví dụ như máy chủ ảo của mình trên GCP đang có host là **35.235.107.213** hoặc nếu cài đặt cả Rasa server và Rasa UI trên cùng 1 máy thì thay bằng **localhost**, cổng vẫn lầ cổng **5005**.

## Running

1. Start Rasa server(ở trong thư mục chính của project)

    ```sh
    rasa run --enable-api --cors "*" --debug 
    ```
    Rasa server sẽ được start lên ở địa chỉ: http://localhost:5005
2. Run npm start từ thư mục rasa_ui(ChatSys/rasa-ui)

    ```sh
    cd ChatSys/rasa-ui
    npm start
    ```

    Bạn sẽ thấy web server của bạn được start tại http://localhost:5001
    
    Bạn sẽ thây giao diện admin ở đây. **username/password** :**admin/admin**
3. Để thực hiện test chatbot đã cấu hình và huấn luyện trên trang admin của rasa-ui, chúng tôi đã giả lập một trang web với một màn hình duy nhất được đặt trong thư mục **trivago**. Để chạy web này, bạn cần di chuyển đển thư mục làm việc của trivago.

    ```sh
    cd ChatSys/trivago
    python server.py
    ```
    Web sẽ được chạy trên địa chỉ http://localhost:8000/chattest/

4. Để test tích hợp lên các trang web khác, hãy chèn đoạn code dưới đây bào trong thân [body]...[/body] của file html. Trong trường hợp demo ở trivago, mình chèn sẵn đoạn mã này vào trong file **index.html** trong thư mục **trivago/templates**. Cần sử dụng trên các website khác chỉ cần copy đoạn này vào. Cơ chế giao tiếp sử dụng socket.io, mình đã cấu hình sẵn trong Rasa server.

```js
<div id="webchat"/>
    <script src="https://storage.googleapis.com/mrbot-cdn/webchat-latest.js"></script>
    <script>
      WebChat.default.init({
        selector: "#webchat",
        customData: {"language": "en"},
        socketUrl: "http://35.235.107.213:5005",
        socketPath: "/socket.io/",
        title: "Chatbot",
        subtitle: "",
      })
    </script>
```

Trong đó phần **socketUrl** bạn đổi host thành host máy chủ Rasa của bạn, ví dụ đây chính là địa chỉ IP máy chủ GCP của mình. Nếu chạy cả client và server để test trên local, có thể để là **localhost**.
5. Để tự động hóa việc run các service, chạy các lệnh:

    ```sh
    ./start.sh # start các service
    ./stop.sh # stop các service
    ./restart.sh # restart các service
    ```

#### Hướng dẫn sử dụng Docker

Để sử dụng Docker để deploy dự án này, bạn không cần cài bất cứ thứ gì ngoài Docker và Docker compose, hãy đảm bảo chúng có sẵn trên máy.

Đầu tiên, đảm bảo bạn terminal của bạn đang làm việc trong thư mục gốc **ChatSys**, sau đó thực hiện lệnh:

```sh
sudo docker-compose up
```

Sau khi lệnh này được chạy xong, hãy lập tức vào địa chỉ http://localhost:5001/ để kiểm tra server Rasa UI đã hoạt động hay chứa, sau đó tiếp tục vào http://localhost:5005/ kiểm tra version hiện sử dụng của Rasa. Khi cả 2 điều này đã thực hiện được, bạn đã thực sự build được toàn bộ chương trình. Chatbot sẽ được kết nối ra ngoài qua http://localhost:5005/ chính là host server của Rasa server.

Để test chatbot có kết nối được hay không, hay quay trở lại với project demo trivago. Trivago đã được kết nối sẵn với chatbot nếu server chatbot đang hoạt động.

```python
source chatsys_env/bin/activate
cd trivago
python server.py
```

Để thực hiện test chatbot trên bất kì trang web nào chạy ở local của bạn, hãy thêm đoạn JS sau vào [body]...[/body] của khung html.

```js
<div id="webchat"/>
    <script src="https://storage.googleapis.com/mrbot-cdn/webchat-latest.js"></script>
    <script>
      WebChat.default.init({
        selector: "#webchat",
        customData: {"language": "en"},
        socketUrl: "http://35.235.107.213:5005",
        socketPath: "/socket.io/",
        title: "Chatbot",
        subtitle: "",
      })
    </script>
```

Thay localhost bằng địa chỉ External IP máy của bạn nếu muốn test với các chatbot ngoài mạng.