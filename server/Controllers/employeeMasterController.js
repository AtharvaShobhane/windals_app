import db from "../Database/connection.js";
import bcrypt from "bcrypt";
import jwt from "jsonwebtoken";
import dotenv from "dotenv"
import path from "path"
import {fileURLToPath} from 'url';

const __filename = fileURLToPath(import.meta.url);
const __dirname = path.dirname(__filename);
dotenv.config({ path: path.join(__dirname, '../.env') });
const JWT_SECRET = process.env.JWT_SECRET;

async function insertIntoEmployeeMaster(req, res) {
    var {
      userName,
      firstName,
      lastName,
      nickName,
      password,
      designation,
      joiningDate,
      mobileNo,
    } = req.body;
    
    if (mobileNo === '') {
      mobileNo = null;
    }
  
    try {
      const searchUserNameQuery = "SELECT employee_id FROM employee_master WHERE user_name = ?";
      const [searchUserNameResult] = await db.promise().query(searchUserNameQuery, [userName]);
  
      const searchMobileNoQuery = "SELECT employee_id FROM employee_master WHERE mobile_no = ?";
      const [searchMobileNoResult] = await db.promise().query(searchMobileNoQuery, [mobileNo]);
  
      if (searchUserNameResult.length > 0) {
        res.status(409).send({ msg: "User name already exists. Use another username." });
      } else if (searchMobileNoResult.length > 0) {
        res.status(409).send({ msg: "Mobile number already exists. Enter a different mobile no." });
      } else {
        bcrypt.hash(password, 10, async (err, hash) => {
          if (err) {
            res.status(409).send({ msg: `SERVER ERROR: Error in encrypting password: ${err}` });
          } else {
            const insertQuery =
              "INSERT INTO employee_master (user_name,first_name,last_name,nick_name,password,designation,joining_date,mobile_no) VALUES (?,?,?,?,?,?,?,?)";
  
            try {
              const [insertResult] = await db
                .promise()
                .query(insertQuery, [userName, firstName, lastName, nickName, hash, designation, joiningDate, mobileNo]);
              
              res.status(201).send({ msg: "Record inserted successfully", insertedId: insertResult.insertId });
            } catch (error) {
              console.error("Database error:", error);
              res.status(500).send({ msg: `Internal server error: ${error}` });
            }
          }
        });
      }
    } catch (error) {
      console.error("Database error:", error);
      res.status(500).send({ msg: `Internal server error: ${error}` });
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

// async function login(req, res) {
//     const { userName, password } = req.body;
//     try {
//       const selectUserQuery = "SELECT password,employee_id,user_name FROM employee_master WHERE user_name = ?";
//       const [selectUserResult] = await db.promise().query(selectUserQuery, [userName]);
//       if (selectUserResult.length === 0) {
//         res.status(401).send({ msg: "Username does not exist" });
//         return;
//       } else {
//         const hashedPassword = selectUserResult[0].password;
//         bcrypt.compare(password, hashedPassword, (err, result) => {
//           if (err) {
//             res.status(500).send({ msg: `Internal server error: ${err}` });
//             return;
//           } else if (result) {
//             res.status(201).send({ msg: "Login successful",employeeId:selectUserResult[0].employee_id,userName:selectUserResult[0].user_name });
//             return;
//           } else {
//             res.status(401).send({ msg: "Invalid password" });
//             return;
//           }
//         });
//       }
//     } catch (error) {
//       console.error("Database error:", error);
//       res.status(500).send({ msg: `Internal server error: ${error}` });
//     }
//   }

  async function login(req, res) {
    const { userName, password } = req.body;
    // console.log(JWT_SECRET)
    try {
      const selectUserQuery = "SELECT password,employee_id,user_name FROM employee_master WHERE user_name = ?";
      const [selectUserResult] = await db.promise().query(selectUserQuery, [userName]);
      if (selectUserResult.length === 0) {
        res.status(401).send({ msg: "Error:Username does not exist" });
        return;
      } else {
        const hashedPassword = selectUserResult[0].password;
        bcrypt.compare(password, hashedPassword, (err, result) => {
          if (err) {
            res.status(500).send({ msg: `Error:Internal server error: ${err}` });
            return;
          } else if (result) {
             const token = jwt.sign({
              userId: selectUserResult[0].employee_id,
              designation: selectUserResult[0].designation
            },JWT_SECRET,{
              expiresIn: "12h"
            })
            res.status(201).send({ msg: "Done:Login successful",employeeId:selectUserResult[0].employee_id,userName:selectUserResult[0].user_name,token:token });
            return;
          } else {
            res.status(401).send({ msg: "Error:Invalid password"});
            return;
          }
        });
      }
    } catch (error) {
      console.error("Database error:", error);
      res.status(500).send({ msg: `Internal server error: ${error}` });
    }
  }

async function getNamesFromEmployeeMaster(req,res){
  try {
    const selectQuery = "SELECT DISTINCT first_name,last_name,user_name,employee_id from employee_master"
    const [selectResult] = await db.promise().query(selectQuery)
    res.status(201).send(selectResult)
  } catch (error) {
      console.error("Database error:", error);
      res.status(500).send({ msg: `Internal server error: ${error}` });
  }
}

export {insertIntoEmployeeMaster,getAllFromEmployee,getOneFromEmployee,updateEmployee,login,getNamesFromEmployeeMaster}