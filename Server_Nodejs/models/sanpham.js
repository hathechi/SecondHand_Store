
// Trong file sanpham.js
import { Model, DataTypes } from 'sequelize';
import mydb from '../config/connect_mysql.js';
import DanhMuc from './danhmuc.js';
import NguoiDung from './nguoidung.js';
import Image from './image.js';

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
        type: DataTypes.INTEGER
    },

    gia: {
        type: DataTypes.DOUBLE
    },
    mo_ta: {
        type: DataTypes.STRING
    },
    sdt: {
        type: DataTypes.STRING
    },
    diachi: {
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
