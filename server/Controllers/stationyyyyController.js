import db from "../Database/connection.js";

async function insertInStationyyyyFirst(req,res){
    const {product_name, station_id, job_name,  employee_id} = req.body;
    
    try {
        const searchQuery = "SELECT job_id FROM productyyyy WHERE job_name=?"
        const [selectResult] = await db.promise().query(searchQuery,[job_name])
        const job_id=selectResult[0]["job_id"];

        const insertQuery = "INSERT INTO station_yyyy (product_name, station_id, job_id, employee_id,status,intime) VALUES (?, ?, ?,?,1,NOW())";
        const [insertResult] = await db.promise().query(insertQuery, [product_name, station_id, job_id,employee_id]);
            
        res.status(201).send({ msg: "Record inserted successfully"});
        
    } catch (err) {
        console.error("Database error:", err);
        res.status(500).send({ msg: `Internal server error: ${err}` });
    }

}

export {insertInStationyyyyFirst};