import express from 'express';
import uploadImage from '../controllers/upload_image.js';
var router = express.Router();

router.post('/api/upload', uploadImage);

export default router;