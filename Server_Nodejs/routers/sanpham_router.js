import express from 'express';
var router = express.Router();
import sanpham_controller from '../controllers/sanpham_controller.js'
import upload from '../controllers/upload_image.js';

//Router Sản Phẩm
// router.get('/api/sanpham', sanpham_controller.getAllData);
router.get('/api/sanpham/user', sanpham_controller.getByID);
router.get('/api/sanpham', sanpham_controller.getPage);
router.post('/api/sanpham', sanpham_controller.insertData)
router.put('/api/sanpham', sanpham_controller.updateData)
router.delete('/api/sanpham', sanpham_controller.deleteData)

/*
*/

export default router;