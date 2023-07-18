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
    url_avatar: {
        type: DataTypes.STRING(200),
        allowNull: false
    },

}, {
    tableName: 'nguoidung',
    timestamps: false
});

export default NguoiDung;
