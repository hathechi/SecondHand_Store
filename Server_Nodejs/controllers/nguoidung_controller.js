
import NguoiDung from '../models/nguoidung.js';


const getAllData = async (req, res) => {
    try {
        const dataAll = await NguoiDung.findAll();
        // console.log(dataAll)
        res.json(dataAll);
    }
    catch (error) {
        console.error(error);
        throw error;
    }
};

//get by id
const getByEmail = async (email) => {
    try {
        const data = await NguoiDung.findOne({
            where: { email: email }
        });
        return data ? data['dataValues'] : null;
    } catch (error) {
        console.error(error);
        throw error;
    }
}



//insert data 
const insertData = async (req, res) => {
    try {
        //nếu tìm được email từ client gửi lên tức là email đã trùng 
        const dataByEmail = await getByEmail(req.body.email);

        if (dataByEmail != null) {
            console.log({ data: dataByEmail })
            return res.status(200).json({ status: true, data: dataByEmail });
        } else {
            await NguoiDung.create({
                ten: req.body.ten,
                email: req.body.email,
                url_avatar: req.body.url_avatar,
            }).then(result => {
                console.log({ status: true, data: result.dataValues })
                return result ? res.status(200).json({ status: true, data: result.dataValues }) : res.status(404).json({ status: false, message: "insert false" })
            });
        }

    } catch (error) {
        console.log(error)
        throw error
    }
}

//export với nhiều hàm khi sử dụng export default
const exportObject = {
    getAllData,
    getByEmail,
    insertData,
};
export default exportObject;