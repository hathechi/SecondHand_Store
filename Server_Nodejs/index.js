import bodyParser from 'body-parser';
import express from 'express';
import { Server } from 'socket.io'; // Thêm socket.io module
import http from 'http'; // Thêm http module

const app = express()

//server SOCKET.IO để sử dụng với Chat realtime
import io from './config/socket.io.js';

//app để sử dụng các thành phần còn lại trong server
const server = http.createServer(app);
io.attach(server); // Gắn socket.io vào server



app.use(express.json());
//để xem được ảnh trong thư mục uploads, thêm dòng dưới
app.use('/uploads', express.static('uploads'));

app.use(bodyParser.urlencoded({ extended: false }))
app.use(bodyParser.json())

//connect MySQL 
import sequelize from './config/connect_mysql.js'
try {
    await sequelize.authenticate();
    console.log('Connection successfully.');
} catch (error) {
    console.error('Unable to connect to the database:', error);
}

//-----------------------------------------------------------------

//Sản Phẩm
import sanPham_router from './routers/sanpham_router.js'
app.use(sanPham_router);
//Danh Mục
import danhMuc_router from './routers/danhmuc_router.js'
app.use(danhMuc_router);
//Nguoidung
import nguoiDung_router from './routers/nguoidung_router.js'
app.use(nguoiDung_router);
//-----------------------------------------------------------------
//upload image
import upload from './routers/upload_router.js'
app.use(upload);

//-----------------------------------------------------------------


// Middleware để xử lý yêu cầu không tìm thấy (404)
app.use((req, res) => {
    res.status(404).send("Không tìm thấy trang");
});


server.listen(process.env.PORT || 4000, () => {
    console.log('Server is running on port:', process.env.PORT);
});

//Start Server với SOCKET.IO // Gọi hàm từ bên socket config
// const server = createServer(app)

// const server = http.createServer(app);
// const io = new Server(server);
// Xử lý các kết nối từ các client
// io.on('connection', (socket) => {
//     console.log('Người dùng đã kết nối:', socket.id);

//     // Xử lý sự kiện khi người dùng gửi tin nhắn mới
//     socket.on('chat message', (message) => {
//         console.log('Tin nhắn mới từ người dùng:', message);

//         // Gửi tin nhắn lại cho tất cả người dùng kết nối
//         io.emit('chat message', message);
//     });

//     // Xử lý sự kiện khi người dùng tham gia phòng chat
//     socket.on('join', (username) => {
//         // ... (các xử lý khác nếu cần)
//     });

//     // Xử lý sự kiện khi người dùng rời khỏi phòng chat
//     socket.on('disconnect', () => {
//         // ... (các xử lý khác nếu cần)
//     });
// });


//Start Server với express
// app.listen(process.env.PORT || 4000, () => {
//     console.log('Server is running on port:', process.env.PORT);
// });