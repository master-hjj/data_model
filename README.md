## Data_model

#### 前端：

1. 安装Node.js

2. 管理员权限命令行进入源代码的front目录。

3. `npm install --registry=https://registry.npmmirror.com`

4. `npm run dev`，之后直接在vscode的Terminal中启动即可

5. 如果遇到`localhost`无法正常解析，可以尝试修改`vue.config.js`文件中`proxy`内容：

   ```vue
   proxy: {
         // detail: https://cli.vuejs.org/config/#devserver-proxy
         [process.env.VUE_APP_BASE_API]: {
           target: `http://127.0.0.1:5000`,			//注意添加http网络协议
           //target: 'http://192.168.3.85:5000',
           // target: `http://192.168.3.116:5000`,
           // target:'http://10.2.117.149:5000',
           changeOrigin: true,
           pathRewrite: {
             ['^' + process.env.VUE_APP_BASE_API]: ''
           }
         },
       },
   ```

#### 后端

##### 可选。若初次安装，数据库没有数据

1. 删除`migrations`文件夹
2. 执行`db_migrate.py`
3. 执行`sydata_sql`文件夹下`sql`文件，个别文件初次导入报错，是有前置数据库，全部执行完之后重新导入即可

##### 已有数据库

1. 建议创建新的虚拟环境

2. 安装依赖`pip install -r requirements1.txt `

3. 修改`config.py DevelopmentConfig`类下的数据库连接，提供用户名密码。   注意防止特殊字符转义，如`@#`等特殊符号

   ```python
   from urllib.parse import quote_plus
   
   class DevelopmentConfig(Config):
       DEBUG = True
       MAIL_SERVER = 'smtp.qq.com'
       MAIL_PORT = 587
       MAIL_USE_TLS = True
       MAIL_USERNAME = os.environ.get('MAIL_USERNAME')
       MAIL_PASSWORD = os.environ.get('MAIL_PASSWORD')
   
       # HOSTNAME = 'mysql.sqlpub.com'
       HOSTNAME = '127.0.0.1'
       PORT = '3306'
       DATABASE = '601_data_model'
       USERNAME = 'root'
       PASSWORD = '@@@@@@@@'
   
       # 对用户名和密码进行URL编码
       encoded_username = quote_plus(USERNAME)
       encoded_password = quote_plus(PASSWORD)
   
       DB_URI = 'mysql+mysqlconnector://{}:{}@{}:{}/{}?charset=utf8'.format(encoded_username, encoded_password, HOSTNAME, PORT, DATABASE)
       SQLALCHEMY_DATABASE_URI = DB_URI
   
   ```

   