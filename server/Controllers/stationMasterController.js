import db from "../Database/connection.js";

async function insertIntoStationMaster(req,res){
    const {stationName,
        productName,
        report,
        stationParameters,
        cycleTime,
        dailyCount,
        productPerHour} = req.body
    try {
        const selectQuery = "SELECT station_id FROM station_master WHERE station_name = ? && product_name = ?"
        const [selectResult] = await db.promise().query(selectQuery,[stationName,productName])
        if(selectResult.length > 0 ){
            res.status(409).send({msg:"Product configuration already exists for this station."})
        }
        else{
            insertQuery = "INSERT INTO station_master (station_name, product_name, report, station_parameters, cycle_time, daily_count, product_per_hour) VALUES (?,?,?,?)"
            const [insertQuery] = await db.promise().query(insertQuery,[stationName,productName,report,stationParameters,cycleTime,dailyCount,productPerHour])
            res.status(201).send({ msg: "Record inserted successfully" });
        }
    } catch (error) {
        console.error("Database error:", err);
        res.status(500).send({ msg: `Internal server error: ${err}` });
    }
}

async function deleteFromStationMaster(req,res){
    const {stationId,stationName,productName} = req.query
    try{
        const selectQuery = "SELECT station_id FROM station_master WHERE station_name = ? && product_name = ?"
        const [selectResult] = await db.promise().query(selectQuery,[stationName,productName])
        if(selectResult.length === 0 ){
            res.status(409).send({msg:"The station configuration of this product does not exist."})
        }
        else{
            const deleteQuery = "DELETE FROM station_master WHERE station_id = ?"
            const [deleteResult] = await db.promise().query(deleteQuery,[stationId])
            res.status(201).send({msg:`Station: ${selectResult[0].station_name} configuration of product: ${selectResult[0].product_name} deleted from database successfully`})
        } 
    }catch(error){
        console.error("Database error:", err);
        res.status(500).send({ msg: `Internal server error: ${err}` });
    }
}

async function updateStationMaster(req,res){
    const {stationName,
        productName,
        report,
        stationParameters,
        cycleTime,
        dailyCount,
        productPerHour} = req.body
        try {
            const selectQuery = "SELECT station_id FROM station_master WHERE station_name = ? && product_name = ?"
            const [selectResult] = await db.promise().query(selectQuery,[stationName,productName])
            if(selectResult.length === 0 ){
                res.status(409).send({msg:"The station configuration of this product does not exist."})
            }
            else{
                const updateQuery = "UPDATE station_master set station_name = ?, product_name = ?, report = ?, station_parameters = ?, cycle_time = ?, daily_count = ?, product_per_hour = ? WHERE station_id = ?"
                const [updateResult] = await db.promise().query(updateQuery,[stationName,productName,report,stationParameters,cycleTime,dailyCount,productPerHour])
                res.status(201).send({msg:`Data updated successfully`})
            } 
        } catch (error) {
            console.error("Database error:", err);
            res.status(500).send({ msg: `Internal server error: ${err}` });
        }
}

async function getInfoFromStationMaster(req,res){
    try{
        var query = "SELECT * FROM station_master"
        const [result] = await db.promise().query(query)
        if(result.length===0){
            res.status(409).send({msg:"No infomation about stations exist in database."})
        }
        else{
            res.status(201).send(result)
        }
    }catch(err){
        console.error("Database error:", err);
        res.status(500).send({msg:`Internal server error: ${err}`})
    }
}

async function getOneStationFromStationMaster(req,res){
    const {stationName} = req.body
    try {
        const searchQuery = "SELECT * FROM station_master WHERE station_name = ?"
        const [searchResult] = await db.promise().query(searchQuery,[stationName])
        if(searchResult.length === 0){
            res.status(409).send({msg:"No such station exist in database."})
        }
        else{
            res.status(201).send({searchResult})
        }        
    } catch (error) {
        console.error("Database error:", err);
        res.status(500).send({msg:`Internal server error: ${err}`})
    }
}

async function getOneStationOneProductFromStationMaster(req,res){
    const {stationName,productName} = req.body
    try {
        const searchQuery = "SELECT * FROM station_master WHERE station_name = ? AND product_name = ?"
        const [searchResult] = await db.promise().query(searchQuery,[stationName,productName])
        if(searchResult.length === 0){
            res.status(409).send({msg:"Station configuration of this product does not exist in database."})
        }
        else{
            res.status(201).send({searchResult})
        }        
    } catch (error) {
        console.error("Database error:", err);
        res.status(500).send({msg:`Internal server error: ${err}`})
    }
}

export {insertIntoStationMaster,deleteFromStationMaster,getInfoFromStationMaster,getOneStationFromStationMaster,getOneStationOneProductFromStationMaster,updateStationMaster}