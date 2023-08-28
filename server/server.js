import bodyParser from "body-parser"
import express from "express"
import cors from 'cors'
import db from "./Database/connection.js";
import router from "./Router/router.js";

const app = express();

app.use(bodyParser.urlencoded({ extended: false }))
app.use(express.json())
app.use(cors())

db.getConnection((err, connection) => {
    if (err) {
        console.error('Database connection error:', err);
    } else {
        console.log('Database connected');
        
        app.listen(8080, () => {
            console.log("Listening on port 8080");
        });
    }

    // Release the connection back to the pool
    // connection.release();
});

app.get('/',(req,res)=>{
    res.status(200).send("connected")
})

app.use('/api',router)