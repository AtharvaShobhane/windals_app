import db from "../Database/connection.js";

async function insertIntoEmployeeMaster(req,res){
    const { designation, emp_first_name, emp_last_name,  joining_date, password } = req.body;

    try {
        const searchQuery = "SELECT id FROM employee WHERE emp_first_name = ? && emp_last_name = ?"
        const [searchResult] = await db.promise().query(searchQuery,[emp_first_name,emp_last_name])
        if(searchResult.length>0)
        {
            res.status(409).send({msg:"Respective employee already exist in database."})
        }
        else
        {

            const insertQuery = "INSERT INTO employee (designation, emp_first_name, emp_last_name,  joining_date, password) VALUES (?, ?, ?, ?,?)";
            const [insertResult] = await db.promise().query(insertQuery, [designation, emp_first_name, emp_last_name,  joining_date,password]);
            res.status(201).send({ msg: "Record inserted successfully", insertedId: insertResult.insertId });
        }
        
    } catch (err) {
        console.error("Database error:", err);
        res.status(500).send({ msg: `Internal server error: ${err}` });
    }

}

async function getAllFromEmployee(req,res){
    try{
        var query = "SELECT * FROM employee"
        const [result] = await db.promise().query(query)
        res.status(201).send(result)
    }catch(err){
        console.error("Database error:", err);
        res.status(500).send({msg:`Internal server error: ${err}`})
    }
}

async function getOneFromEmployee(req,res){
    const {emp_first_name, emp_last_name, designation} = req.body
    try{
        var query="SELECT * FROM employee WHERE emp_first_name = ? && emp_last_name = ? && designation=?"
        const [result]= await db.promise().query(query,[emp_first_name,emp_last_name,designation]);
        if(result.length>0)
        {
            res.status(201).send(result)
        }
        else{
            console.log("Employee does not exist in the database")
        }
    }catch(err){
        console.error("Database error",err);
        res.status(500).send({msg:`Internal server error: ${err}`})
    }
}

async function updateEmployee(req,res){
    const {employee_id, updatedFields} = req.body
    try{
        const setClause= Object.keys(updatedFields).map(key => `${key}=?`).join(",");
        const values= Object.values(updatedFields);

        values.push(employee_id);

        const query=`UPDATE employee SET ${setClause} WHERE employee_id = ?`;
        const [updateResult]=db.promise().query(query,values);

        if (updateResult.affectedRows === 0) {
            return res.status(404).send({ msg: "Employee not found" });
        }

        res.status(200).send({ msg: "Employee data updated successfully" });
    }
    catch(err){
        console.error("Database error:", err);
        res.status(500).send({ msg: `Internal server error: ${err}` });
    }
}

export {insertIntoEmployeeMaster,getAllFromEmployee,getOneFromEmployee,updateEmployee}