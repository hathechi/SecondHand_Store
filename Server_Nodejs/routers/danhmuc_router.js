import express from 'express';
var router = express.Router();
import danhmuc_controller from '../controllers/danhmuc_controller.js'

//Router Sản Phẩm
router.get('/api/danhmuc', danhmuc_controller.getAllData);
router.get('/api/danhmuc/:id', danhmuc_controller.getByID);
router.post('/api/danhmuc', danhmuc_controller.insertData)
router.put('/api/danhmuc', danhmuc_controller.updateData)
router.delete('/api/danhmuc', danhmuc_controller.deleteData)


export default router;