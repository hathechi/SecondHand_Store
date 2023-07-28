// models/conversation.js
import { DataTypes } from 'sequelize';
import sequelize from '../config/connect_mysql.js';
import NguoiDung from './nguoidung.js';

const Conversation = sequelize.define(
    'conversation',
    {
        id: {
            type: DataTypes.INTEGER,
            autoIncrement: true,
            allowNull: false,
            primaryKey: true,
        },
        userId1: {
            type: DataTypes.INTEGER,
            allowNull: false,
        },
        userId2: {
            type: DataTypes.INTEGER,
            allowNull: false,
        },

    },
    {
        tableName: 'conversation',
        timestamps: false,
    }
);
// Định nghĩa mối quan hệ giữa Conversation và Nguoidung
Conversation.belongsTo(NguoiDung, { foreignKey: 'userId1', as: 'nguoidung1' });
Conversation.belongsTo(NguoiDung, { foreignKey: 'userId2', as: 'nguoidung2' });

export default Conversation;
