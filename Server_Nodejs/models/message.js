// models/message.js
import { DataTypes } from 'sequelize';
import mydb from '../config/connect_mysql.js';


const Message = mydb.define('message', {
    id: {
        type: DataTypes.INTEGER,
        primaryKey: true,
        autoIncrement: true
    },
    id_nguoigui: {
        type: DataTypes.INTEGER,
        allowNull: false,
    },
    id_nguoinhan: {
        type: DataTypes.INTEGER,
        allowNull: false,
    },
    message: {
        type: DataTypes.STRING,
        allowNull: false,
    },
    timestamp: {
        type: DataTypes.DATE,
        allowNull: false,
        defaultValue: DataTypes.NOW,
    },
}, {
    tableName: 'message',
    timestamps: true
});

export default Message;
