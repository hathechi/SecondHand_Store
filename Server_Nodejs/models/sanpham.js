
// Trong file sanpham.js
import { Model, DataTypes } from 'sequelize';
import mydb from '../config/connect_mysql.js';
import DanhMuc from './danhmuc.js';
import NguoiDung from './nguoidung.js';
import Image from './image.js';

// class SanPham extends Model {

// }

// SanPham.init(
//     {

//         // Các thuộc tính của bảng sanpham
//         id_sanpham: {
//             type: DataTypes.INTEGER,
//             primaryKey: true,
//             autoIncrement: true
//         },
//         ten_sanpham: {
//             type: DataTypes.STRING,
//             allowNull: true
//         },
//         id_nguoidung: {
//             type: DataTypes.INTEGER,
//             allowNull: false
//         },
//         id_danhmuc: {
//             type: DataTypes.INTEGER,
//             allowNull: false
//         },
//         ngay_tao: {
//             type: DataTypes.STRING,
//             allowNull: true
//         },
//         gio_tao: {
//             type: DataTypes.STRING,
//             allowNull: true
//         },
//         gia: {
//             type: DataTypes.FLOAT,
//             allowNull: true
//         },
//         mo_ta: {
//             type: DataTypes.STRING,
//             allowNull: true
//         }
//     },
//     {
//         modelName: 'sanpham',
//         sequelize: mydb,
//         timestamps: false,
//     }
// );
// SanPham.belongsTo(DanhMuc); // Thiết lập quan hệ với model DanhMuc
// SanPham.belongsTo(NguoiDung); // Thiết lập quan hệ với model NguoiDung

// export default SanPham;
// Định nghĩa model cho bảng SanPham
const SanPham = mydb.define('sanpham', {
    id_sanpham: {
        type: DataTypes.INTEGER,
        primaryKey: true,
        autoIncrement: true
    },
    ten_sanpham: {
        type: DataTypes.STRING
    },
    id_nguoidung: {
        type: DataTypes.INTEGER
    },
    id_danhmuc: {
        type: DataTypes.INTEGER
    },
    ngay_tao: {
        type: DataTypes.DATE
    },
    gio_tao: {
        type: DataTypes.STRING
    },
    gia: {
        type: DataTypes.INTEGER
    },
    mo_ta: {
        type: DataTypes.STRING
    },
    status: {
        type: DataTypes.BOOLEAN
    },
    // createdAt: {
    //     field: 'created_at',
    //     type: DataTypes.DATE
    // },
    // updatedAt: {
    //     field: 'updated_at',
    //     type: DataTypes.DATE
    // }
}, {
    tableName: 'sanpham',
    timestamps: false
});

// Thiết lập quan hệ giữa các bảng
SanPham.belongsTo(DanhMuc, { foreignKey: 'id_danhmuc' });
SanPham.belongsTo(NguoiDung, { foreignKey: 'id_nguoidung' });
SanPham.belongsTo(Image, { foreignKey: 'id_sanpham' });

export default SanPham;
