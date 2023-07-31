import SanPham from '../models/sanpham.js';
import DanhMuc from '../models/danhmuc.js';
import NguoiDung from '../models/nguoidung.js';
import Image from '../models/image.js'
//Cache
import NodeCache from 'node-cache';
const cache = new NodeCache();

import { Sequelize } from 'sequelize';


// const getAllData = async (req, res) => {
//     let page = !req.query.page ? 1 : req.query.page
//     let limit = !req.query.page ? 5 : req.query.page



//     try {
//         const cacheKey = 'getAllData'; // Khóa cache

//         // Kiểm tra xem dữ liệu có tồn tại trong cache không
//         const cachedData = cache.get(cacheKey);
//         if (cachedData) {
//             console.log('Trả về dữ liệu từ cache', cachedData);
//             res.json(cachedData);

//         } else {
//             const dataAll = await SanPham.findAll({
//                 include: [
//                     {
//                         model: DanhMuc,
//                         attributes: ['ten_danhmuc'],
//                     },
//                     {
//                         model: NguoiDung,
//                         attributes: ['ten'],
//                     }
//                 ],
//                 order: [['id_sanpham', 'DESC']],
//             })
//             //dữ liệu trả về khi đã loại bỏ key không mong muốn
//             const modifiedData = await removeKey(dataAll);
//             const arrImageProduct = await getArrImage(modifiedData);

//             // Lưu dữ liệu vào cache và đặt thời gian sống (ttl) cho cache
//             cache.set(cacheKey, arrImageProduct, 60); // Ví dụ: cache tồn tại trong 60 giây

//             console.log(arrImageProduct)
//             res.json(arrImageProduct);
//         }



//     } catch (error) {
//         console.error(error);
//         throw error;
//     }
// };
//loại bỏ các key danhmuc, nguoidung không cần thiết
const removeKey = async (data) => {
    const modifiedData = await data.map(item => {
        return {
            //thêm toJson() vào để parse json
            ...item.toJSON(),
            danhmuc: item['danhmuc']['ten_danhmuc'], // Đổi key 'ten_danhmuc' thành 'danhmuc'
            nguoidung: item['nguoidung']['ten'] // Đổi key 'ten' thành 'nguoidung'
        };
    });

    return modifiedData
}
//Lấy ArrImage theo id_sanpham của các sản phẩm
const getArrImage = async (modifiedData) => {
    let dataProduct = []
    if (modifiedData != null) {
        //lấy data image của từng sản phẩm bằng cách lặp qua các sản phẩm,dùng id_sanpham lấy các url hình ảnh
        for (let i = 0; i < modifiedData.length; i++) {
            await Image.findAll({ where: { id_sanpham: modifiedData[i].id_sanpham } }).then((image) => {
                if (image != null) {
                    //thêm toJson() vào để parse json
                    // thực hiện ánh xạ (map) qua mảng image và tạo ra một mảng mới chứa các đối tượng mới có thuộc tính url.
                    let item = { ...modifiedData[i], imageArr: image.map(img => img.url) };
                    dataProduct.push(item)
                }
            })
        }
    } else {
        await Image.findAll({ where: { id_sanpham: modifiedData.id_sanpham } }).then((image) => {
            if (image != null) {
                //thêm toJson() vào để parse json
                // thực hiện ánh xạ (map) qua mảng image và tạo ra một mảng mới chứa các đối tượng mới có thuộc tính url.
                let item = { ...modifiedData.toJSON(), imageArr: image.map(img => img.url) };
                dataProduct.push(item)
            }
        })
    }
    return dataProduct
}

//get by id
const getByID = async (req, res) => {
    try {

        const dataAll = await SanPham.findAll({
            where: { id_nguoidung: req.query.id, status: 0 },
            include: [
                {
                    model: DanhMuc,
                    attributes: ['ten_danhmuc']
                },
                {
                    model: NguoiDung,
                    attributes: ['ten']
                }
            ],

            order: [['id_sanpham', 'DESC']]
        });

        if (dataAll.length > 0) {
            // let sanphams = (await SanPham.findAll()).length;
            // let totalPage = customRound(sanphams / limit);
            //dữ liệu trả về khi đã get ArrImage và loại bỏ key không mong muốn
            const modifiedData = await removeKey(dataAll);
            const arrImageProduct = await getArrImage(modifiedData);
            res.status(200).json({ length: dataAll.length, arrImageProduct })
        } else {
            res.status(404).json('NO DATA');
        }
    } catch (error) {
        console.error(error);
        throw error;
    }
}

//get page
const getPage = async (req, res) => {

    try {
        let page = req.query.page ? Number(req.query.page) : 1
        let limit = req.query.limit ? Number(req.query.limit) : 5

        let offset = (page - 1) * limit

        const { count, rows } = await SanPham.findAndCountAll({
            where: { status: 0 },
            include: [
                {
                    model: DanhMuc,
                    attributes: ['ten_danhmuc']
                },
                {
                    model: NguoiDung,
                    attributes: ['ten']
                }
            ],
            offset: offset,
            limit: limit,
            order: [['id_sanpham', 'DESC']]
        });
        if (rows != null) {
            let totalPage = customRound(count / limit);
            //dữ liệu trả về khi đã get ArrImage và loại bỏ key không mong muốn
            const modifiedData = await removeKey(rows);
            const arrImageProduct = await getArrImage(modifiedData);
            res.status(200).json({ "totalPage": totalPage, arrImageProduct })
        } else {
            res.status(404).json('NO DATA');
        }
    } catch (error) {
        console.error(error);
        throw error;
    }
}
//Lấy số trang làm tròn lên
function customRound(number) {
    const decimalPart = number - Math.floor(number);
    if (decimalPart <= 1.5) {
        return Math.ceil(number);
    } else {
        return Math.round(number);
    }
}
const searchByID = async (id) => {
    const search = await SanPham.findOne({
        where: {
            //tìm các sản phẩm có status = 0 (sản phẩm chưa bị xóa)
            status: 0,
            id_sanpham: id
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
        console.log("INSERT: " + req.body)
        if (req.body) {
            await SanPham.create({
                ten_sanpham: req.body.ten_sanpham,
                id_nguoidung: req.body.id_nguoidung,
                id_danhmuc: req.body.id_danhmuc,
                ngay_tao: req.body.ngay_tao,
                gia: req.body.gia,
                mo_ta: req.body.mo_ta,
                sdt: req.body.sdt,
                diachi: req.body.diachi,
                status: false
            }).then((sp) => {
                if (sp) {
                    for (let i = 0; i < req.body.imageArr.length; i++) {
                        Image.create({ url: req.body.imageArr[i], id_sanpham: sp['dataValues'].id_sanpham }).then((img) => {
                            // console.log('IMG', img)
                        })
                    }
                    res.json({ status: true, message: "insert succsess" })
                } else {
                    res.status(404).json({ status: false, message: "insert false" })
                }
            })
        }

        // insert ? res.json({ status: true, message: "insert succsess" + insert }) : res.status(404).json({ status: false, message: "insert false" })
    } catch (error) {
        console.log(error)
        throw error
    }
}
//update data 
const updateData = async (req, res) => {
    try {
        console.log("UPDATE: " + req.body)
        if (await searchByID(req.body.id_sanpham)) {
            await SanPham.update({
                ten_sanpham: req.body.ten_sanpham,
                // id_nguoidung: req.body.id_nguoidung,
                id_danhmuc: req.body.id_danhmuc,
                // ngay_tao: req.body.ngay_tao,
                gia: req.body.gia,
                mo_ta: req.body.mo_ta,
                sdt: req.body.sdt,
                diachi: req.body.diachi,
                // status: false
            },
                { where: { id_sanpham: req.body.id_sanpham } }).then((sp) => {
                    if (sp) {
                        for (let i = 0; i < req.body.imageArr.length; i++) {
                            Image.update({ url: req.body.imageArr[i] }, { where: { id_sanpham: req.body.id_sanpham } }).then((img) => {
                                console.log('UPDATE IMG ', img)
                            })
                        }
                        res.json({ status: true, message: "Update succsess" })
                    } else {
                        res.status(404).json({ status: false, message: "Update false" })
                    }
                })
        } else {
            res.status(404).json({ status: false, message: `id_sanpham ${req.body.id_sanpham} not found` })
        }

        // insert ? res.json({ status: true, message: "insert succsess" + insert }) : res.status(404).json({ status: false, message: "insert false" })
    } catch (error) {
        console.log(error)
        throw error
    }
}

//Delete data 
const deleteData = async (req, res) => {
    console.log("ID DELETE: ", req.body.id_sanpham)
    try {
        if (await searchByID(req.body.id_sanpham)) {
            const deleteData = await SanPham.update({
                status: 1
            }, {
                where: {
                    id_sanpham: req.body.id_sanpham
                }
            })
            deleteData ? res.json({ status: true, message: "delete succsess" }) : res.status(404).json({ status: false, message: "delete false" })
        } else {
            res.status(404).json({ status: false, message: `id_sanpham ${req.body.id_sanpham} not found` })
        }
    } catch (error) {
        throw error
    }
}
const searchProduct = async (req, res) => {
    try {
        let { keyword, minPrice, maxPrice } = req.query;
        console.log(req.query)
        let conditions = {
            status: 0,
            [Sequelize.Op.and]: [], // Tạo điều kiện AND cho các yêu cầu
        };
        if (keyword) {
            if (minPrice !== 'null' && maxPrice !== 'null') {
                conditions[Sequelize.Op.and].push({
                    [Sequelize.Op.or]: [
                        {
                            ten_sanpham: {
                                [Sequelize.Op.like]: `%${keyword}%`
                            },
                        },
                        {
                            '$DanhMuc.ten_danhmuc$': {
                                [Sequelize.Op.like]: `%${keyword}%`
                            },
                        },
                    ],
                    gia: {
                        [Sequelize.Op.between]: [minPrice, maxPrice],
                    }
                });
            } else {
                conditions[Sequelize.Op.and].push({
                    [Sequelize.Op.or]: [
                        {
                            ten_sanpham: {
                                [Sequelize.Op.like]: `%${keyword}%`
                            },
                        },
                        {
                            '$danhmuc.ten_danhmuc$': {
                                [Sequelize.Op.like]: `%${keyword}%`
                            },
                        },
                    ],
                });
            }
        }

        const dataAll = await SanPham.findAll({
            where: conditions,
            include: [
                {
                    model: DanhMuc,
                    attributes: ['ten_danhmuc']
                },
                {
                    model: NguoiDung,
                    attributes: ['ten']
                }
            ],

            order: [['id_sanpham', 'DESC']]
        });
        if (dataAll != null) {

            //dữ liệu trả về khi đã get ArrImage và loại bỏ key không mong muốn
            const modifiedData = await removeKey(dataAll);
            const arrImageProduct = await getArrImage(modifiedData);
            res.status(200).json({ arrImageProduct })
        } else {
            res.status(404).json('NO DATA');
        }
    } catch (error) {
        console.error(error);
        throw error;
    }
}

//export với nhiều hàm khi sử dụng export default
const exportObject = {
    // getAllData,
    getByID,
    getPage,
    insertData,
    updateData,
    deleteData,
    searchProduct
};
export default exportObject;