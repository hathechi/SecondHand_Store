import mysql from 'mysql2';
import dotenv from "dotenv";
dotenv.config();
import { Sequelize } from 'sequelize';


// const sequelize = new Sequelize(process.env.DB_NAME_MYSQL, 'root', '', {
//     dialect: 'mysql',
//     host: "localhost",
//     logging: false
//     // define: {
//     //     timestamps: false,
//     //     underscored: true,
//     // }
// });
const sequelize = new Sequelize(process.env.DB_NAME_MYSQL, process.env.DB_USER, process.env.DB_PASSWORD, {
    host: process.env.DB_HOST,
    dialect: 'mysql',
    port: process.env.PORT_DB

});

// sequelize.sync()
//     .then(() => {
//         console.log('Đã tạo các bảng trong cơ sở dữ liệu.');
//     })
//     .catch((error) => {
//         console.error('Lỗi khi tạo các bảng:', error);
//     });
export default sequelize;