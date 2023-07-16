import multer from 'multer'
// Cấu hình multer để lưu trữ tệp ảnh tải lên
const storage = multer.diskStorage({
    destination: (req, file, cb) => {
        cb(null, 'uploads'); // Đường dẫn thư mục lưu trữ ảnh
    },
    filename: function (req, file, cb) {
        const uniqueSuffix = Date.now() + '-' + Math.round(Math.random() * 1E9)
        cb(null, uniqueSuffix + '-' + file.originalname)
    }
    // filename: (req, file, cb) => {
    //     cb(null, file.originalname); // Giữ nguyên tên tệp ảnh
    // }
});

const upload = multer({ storage });

const uploadImage = (req, res) => {
    upload.array('image')(req, res, (err) => {
        if (err) {
            console.log({ 'message': 'Error uploading images', 'error': err })
            return res.status(400).json({ 'message': 'Error uploading images', 'error': err });
        }

        if (!req.files || req.files.length === 0) {
            console.log({ 'message': 'No images uploaded' })
            return res.status(400).json({ 'message': 'No images uploaded' });
        }

        // Xử lý các ảnh tải lên tại đây (ví dụ: lưu vào cơ sở dữ liệu)
        console.log('Images uploaded successfully', req.files)
        return res.status(200).json('Images uploaded successfully');
    });
};
export default uploadImage   
