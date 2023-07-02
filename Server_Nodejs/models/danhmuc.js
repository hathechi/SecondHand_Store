import { DataTypes } from 'sequelize';
import mydb from '../config/connect_mysql.js';

const DanhMuc = mydb.define('danhmuc', {
    id_danhmuc: {
        type: DataTypes.INTEGER,
        primaryKey: true,
        autoIncrement: true
    },
    ten_danhmuc: {
        type: DataTypes.STRING,
        allowNull: true
    }
}, {
    tableName: 'danhmuc',
    timestamps: false
});

export default DanhMuc;
