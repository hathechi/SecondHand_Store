import dotenv from "dotenv/config.js";
import express from 'express';
import bodyParser from 'body-parser';


var app = express();
app.use(express.json());
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
//-----------------------------------------------------------------

// Middleware để xử lý yêu cầu không tìm thấy (404)
app.use((req, res) => {
    res.status(404).send("Không tìm thấy trang");
});

//Start Server

app.listen(process.env.PORT || 4000, () => {
    console.log('Server is running on port:', process.env.PORT);
});