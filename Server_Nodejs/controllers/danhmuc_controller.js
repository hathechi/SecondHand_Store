
import DanhMuc from '../models/danhmuc.js';

//Cache
import NodeCache from 'node-cache';
const cache = new NodeCache();


const getAllData = async (req, res) => {
    try {
        const cache_danhmuc_Key = 'getAllData_danhmuc'; // Khóa cache

        // Kiểm tra xem dữ liệu có tồn tại trong cache không
        const cachedData = cache.get(cache_danhmuc_Key);
        if (cachedData) {
            console.log('Trả về dữ liệu từ cache', cachedData);
            res.json(cachedData);

        } else {
            const dataAll = await DanhMuc.findAll();
            // Lưu dữ liệu vào cache và đặt thời gian sống (ttl) cho cache
            cache.set(cache_danhmuc_Key, dataAll, 60); // Ví dụ: cache tồn tại trong 60 giây

            // console.log(dataAll)
            res.json(dataAll);
        }

    } catch (error) {
        console.error(error);
        throw error;
    }
};

//get by id
const getByID = async (req, res) => {
    try {
        const dataAll = await DanhMuc.findOne({
            where: { id_danhmuc: req.params.id }
        });
        if (dataAll != null) {
            res.status(200).json(dataAll)
        } else {
            res.status(404).json('NO DATA');
        }
    } catch (error) {
        console.error(error);
        throw error;
    }
}


const searchByID = async (id) => {
    const search = await DanhMuc.findOne({
        where: {
            //tìm các sản phẩm có status = 0 (sản phẩm chưa bị xóa)
            // status: 0,
            id_danhmuc: id
        }
    })
    if (search) {
        return true
    } else {
        return false
    }
}

//insert data 
const insertData = async (req, res) => {
    try {
        const insert = await DanhMuc.create({
            ten_danhmuc: req.body.ten_danhmuc,
        });
        insert ? res.json({ status: true, message: "insert succsess" + insert }) : res.status(404).json({ status: false, message: "insert false" })
    } catch (error) {
        console.log(error)
        throw error
    }
}
//update data 
const updateData = async (req, res) => {
    try {
        //tìm sản phẩm theo id trước, nếu tìm thấy sản phẩm thì mới cập nhật
        if (await searchByID(req.body.id_danhmuc)) {
            const update = await DanhMuc.update({
                ten_danhmuc: req.body.ten_danhmuc,
            },
                { where: { id_danhmuc: req.body.id_danhmuc } });
            console.log(update)
            update ? res.status(200).json({ status: true, message: "update succsess" }) : res.status(404).json({ status: false, message: "update false" })
        } else {
            res.status(404).json({ status: false, message: `id_danhmuc ${req.body.id_danhmuc} not found` })
        }

    } catch (error) {
        console.log(error)
        throw error
    }
}

//Delete data 
const deleteData = async (req, res) => {
    try {
        if (await searchByID(req.body.id_danhmuc)) {
            const deleteData = await DanhMuc.update({
                status: 1
            }, {
                where: {
                    id_danhmuc: req.body.id_danhmuc
                }
            })
            deleteData ? res.json({ status: true, message: "delete succsess" }) : res.status(404).json({ status: false, message: "delete false" })
        } else {
            res.status(404).json({ status: false, message: `id_danhmuc ${req.body.id_danhmuc} not found` })
        }
    } catch (error) {
        throw error
    }
}

//export với nhiều hàm khi sử dụng export default
const exportObject = {
    getAllData,
    getByID,
    insertData,
    updateData,
    deleteData
};
export default exportObject;