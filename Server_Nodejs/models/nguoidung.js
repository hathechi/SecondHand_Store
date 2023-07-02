import { DataTypes } from 'sequelize';
import mydb from '../config/connect_mysql.js';

const NguoiDung = mydb.define('nguoidung', {
    id_nguoidung: {
        type: DataTypes.INTEGER,
        primaryKey: true,
        autoIncrement: true
    },
    ten: {
        type: DataTypes.STRING,
        allowNull: false
    },
    email: {
        type: DataTypes.STRING,
        allowNull: false
    },
    sdt: {
        type: DataTypes.STRING(11),
        allowNull: false
    },
    diachi: {
        type: DataTypes.STRING(300),
        allowNull: false
    }
}, {
    tableName: 'nguoidung',
    timestamps: false
});

export default NguoiDung;
