import mongoose from 'mongoose'
import dotenv from "dotenv";
dotenv.config();
// ---------Connect MongoDB-----------

const connect = async () => {
    try {
        await mongoose.connect(process.env.URL_MONGODB, { useNewUrlParser: true, useUnifiedTopology: true });
        console.log("Connected to MongoDB");
    } catch (error) {
        console.error(error);
    }
}

export default connect;
// module.exports = connect();
