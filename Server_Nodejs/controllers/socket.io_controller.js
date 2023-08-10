import Message from "../models/message.js";
import NguoiDung from '../models/nguoidung.js'
import Conversation from "../models/conversation.js";
// import { Server } from 'socket.io';
// const io = new Server();
import { Sequelize } from "sequelize";

import sequelize from '../config/connect_mysql.js';

// Hàm xử lý sự kiện khi nhận được tin nhắn mới từ client
async function handleMessage(data) {
    const { id_nguoigui, id_nguoinhan, message } = data;
    console.log('data từ client gửi lên: ', data)

    try {
        // Lưu tin nhắn vào cơ sở dữ liệu
        const newMessage = await Message.create({
            id_nguoigui: id_nguoigui,
            id_nguoinhan: id_nguoinhan,
            message: message,
        });
        //trả tin nhắn mới lưu vào db về cho người dùng
        return newMessage

    } catch (error) {
        console.error('Lỗi khi lưu tin nhắn vào cơ sở dữ liệu:', error);
    }
}

// Lưu thông tin cuộc trò chuyện vào cơ sở dữ liệu
async function saveConversationToDatabase(userId1, userId2) {
    console.log({ userId1, userId2 })
    try {
        const query = `SELECT * FROM conversation
         WHERE (userId1 = ${userId1} AND userId2 = ${userId2})
            OR (userId1 = ${userId2} AND userId2 =${userId1})`
        // const isExist = await Conversation.findAll({
        //     where: {
        //         [Sequelize.Op.or]: [
        //             {
        //                 userId1: userId1,
        //                 userId2: userId2,
        //             },
        //             {
        //                 userId1: userId2,
        //                 userId2: userId2,
        //             }
        //         ],

        //     }
        // })
        const isExist = await sequelize.query(query);


        console.log(isExist)
        if (userId1 === userId2 || isExist.length > 0) {
            return;
        }
        else {
            const conversation = await Conversation.create({
                userId1: userId1,
                userId2: userId2,
            });
            return conversation.id;
        }
    } catch (error) {
        console.error('Error saving conversation:', error);
        throw error;
    }
}

const deleteMessage = async (id_message) => {
    try {

        const deleteStatus = await Message.destroy({
            where: {
                id: id_message,
            }
        })
        return deleteStatus;

    } catch (error) {
        console.log(error)
    }
}


// Hàm lấy danh sách cuộc trò chuyện cho id_nguoidung hiện tại
async function getConversations(id_nguoidung) {
    try {

        // const conversations = await Conversation.findAll({
        //     attributes: ['id', 'userId1', 'userId2'],
        //     where: {
        //         [Sequelize.Op.or]: [{ userId1: id_nguoidung }, { userId2: id_nguoidung }],
        //     },
        //     include: [
        //         {
        //             model: NguoiDung,
        //             as: 'nguoidung1',
        //             attributes: ['id_nguoidung', 'ten'],
        //         },
        //         {
        //             model: NguoiDung,
        //             as: 'nguoidung2',
        //             attributes: ['id_nguoidung', 'ten'],
        //         },
        //     ],
        // });

        // const query = `SELECT conversation.id, conversation.userId1, conversation.userId2, nguoidung.id_nguoidung, nguoidung.ten, nguoidung.url_avatar
        //  FROM conversation LEFT JOIN nguoidung ON
        //  (conversation.userId1 = nguoidung.id_nguoidung AND conversation.userId2 = ${id_nguoidung}) 
        //  OR(conversation.userId2 = nguoidung.id_nguoidung AND conversation.userId1 = ${id_nguoidung}) 
        //  WHERE conversation.userId1 = ${id_nguoidung} OR conversation.userId2 = ${id_nguoidung} `;
        const query = `SELECT conversation.id, conversation.userId1, conversation.userId2, nguoidung.id_nguoidung, nguoidung.ten, nguoidung.url_avatar
         FROM conversation LEFT JOIN nguoidung ON
         (conversation.userId1 = nguoidung.id_nguoidung AND conversation.userId2 = ${id_nguoidung}) 
         OR(conversation.userId2 = nguoidung.id_nguoidung AND conversation.userId1 = ${id_nguoidung}) 
         WHERE conversation.userId1 = ${id_nguoidung} OR  conversation.userId2 = ${id_nguoidung}`;
        // Truy vấn cơ sở dữ liệu để lấy danh sách cuộc trò chuyện
        const conversations = await sequelize.query(query);
        if (conversations != null) {
            return conversations;
        }
    } catch (error) {
        console.error('Lỗi khi lấy danh sách cuộc trò chuyện:', error);
        return [];
    }
}



const getHistoryMessage = async (nguoigui, nguoinhan) => {

    try {
        const messages = await Message.findAll({
            where: {
                // Truy vấn dựa vào senderId và receiverId
                //SELECT `id`, `id_nguoigui`, `id_nguoinhan`, `message`, `timestamp`, `createdAt`, `updatedAt` FROM `message` AS `message` WHERE ((`message`.`id_nguoigui` = '1' AND `message`.`id_nguoinhan` = '2') OR (`message`.`id_nguoigui` = '2' AND `message`.`id_nguoinhan` = '1')) ORDER BY `message`.`timestamp` ASC
                [Sequelize.Op.or]: [
                    { id_nguoigui: nguoigui, id_nguoinhan: nguoinhan },
                    { id_nguoigui: nguoinhan, id_nguoinhan: nguoigui },
                ],
            },

            order: [['timestamp', 'ASC']],
        });
        // const query = `SELECT id, id_nguoigui, id_nguoinhan, message, timestamp, createdAt, updatedAt FROM message AS message WHERE ((message.id_nguoigui = ${nguoigui} AND message.id_nguoinhan = ${nguoinhan}) OR (message.id_nguoigui = ${nguoinhan} AND message.id_nguoinhan = ${nguoigui})) ORDER BY message.timestamp ASC`
        // const messages = await Message.query(query);
        return messages;
    } catch (error) {
        console.error('Lỗi khi truy vấn tin nhắn:', error);
        return [];
    }

}

export {
    getHistoryMessage,
    handleMessage,
    getConversations,
    saveConversationToDatabase,
    deleteMessage
}
