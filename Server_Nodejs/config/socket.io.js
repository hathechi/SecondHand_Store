import { Server } from 'socket.io';
const io = new Server();

import { handleMessage, getConversations, getHistoryMessage, saveConversationToDatabase } from '../controllers/socket.io_controller.js'

io.on('connection', (socket) => {
    console.log('Người dùng đã kết nối:', socket.id);

    // Xử lý sự kiện chat message khi nhận được tin nhắn mới từ client
    socket.on('send message', async (data) => {
        console.log('Tin nhắn mới từ người dùng:', data);
        const socketId_nguoidung = data['socketId'];
        await handleMessage(data);
        // Gửi tin nhắn lại cho tất cả người dùng kết nối
        io.emit('chat message', { message: data, socketId: socketId_nguoidung });
    });


    // Xử lý sự kiện get chat history khi client yêu cầu lấy lịch sử tin nhắn cũ
    socket.on('get chat history', async (data) => {
        const { nguoigui, nguoinhan, socketId } = data;
        let message = await getHistoryMessage(nguoigui, nguoinhan);
        // console.log(message)
        // Gửi tin nhắn lại cho tất cả người dùng kết nối
        io.emit(`chat history`, { message: message, socketId: socketId });
    });
    socket.on('save conversation', async (data) => {
        const { userId1, userId2 } = data;
        let message = await saveConversationToDatabase(userId1, userId2);
        console.log(message)
        // Gửi tin nhắn lại cho tất cả người dùng kết nối
        // io.emit('chat history', { message: message });
    });
    socket.on('get conversation', async (data) => {
        const { userId1, socketId } = data;
        console.log('socketID getConversationToDatabase:  ', socketId)
        let message = await getConversations(userId1);

        // Gửi tin nhắn lại cho tất cả người dùng kết nối
        io.emit(`get conversation`, { message: message, 'socketId': socketId });
    });


});

export default io;
