import { DataTypes } from 'sequelize';
import mydb from '../config/connect_mysql.js';

const Image = mydb.define('url_image', {
    id_image: {
        type: DataTypes.INTEGER,
        primaryKey: true,
        autoIncrement: true
    },
    url: {
        type: DataTypes.STRING(2000),
        allowNull: false
    },
    id_sanpham: {
        type: DataTypes.INTEGER,
        allowNull: false
    }
}, {
    tableName: 'url_image',
    timestamps: false
});

export default Image;
