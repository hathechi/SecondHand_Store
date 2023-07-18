import express from 'express';
var router = express.Router();
import nguoidung_controller from '../controllers/nguoidung_controller.js'

//Router Sản Phẩm
router.get('/api/nguoidung', nguoidung_controller.getAllData);
router.get('/api/nguoidung/:email', nguoidung_controller.getByEmail);
router.post('/api/nguoidung', nguoidung_controller.insertData)

export default router;