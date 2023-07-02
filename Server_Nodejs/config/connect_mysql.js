import mysql from 'mysql2';
import dotenv from "dotenv";
dotenv.config();
import { Sequelize } from 'sequelize';


const syquelize = new Sequelize(process.env.DB_NAME_MYSQL, 'root', '', {
    dialect: 'mysql',
    host: "localhost",
    logging: false
    // define: {
    //     timestamps: false,
    //     underscored: true,
    // }
});



export default syquelize;