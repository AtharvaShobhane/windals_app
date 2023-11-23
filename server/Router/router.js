import Router from "express"
import { insertInProductMaster, getInfoFromProductMaster, deleteFromProductMaster, updateProductMaster, getOneProductAllParametersInfoFromProductMaster, getOneProductOneParameterInfoFromProductMaster, getProductNames } from "../Controllers/productMasterController.js";
import {insertIntoStationMaster,deleteFromStationMaster,getInfoFromStationMaster,getOneStationFromStationMaster,getOneStationOneProductFromStationMaster,updateStationMaster} from "../Controllers/stationMasterController.js";
import {insertInProductyyyy} from "../Controllers/productyyyyController.js";
import {insertIntoEmployeeMaster,getAllFromEmployee,getOneFromEmployee,updateEmployee,login,getNamesFromEmployeeMaster} from "../Controllers/employeeMasterController.js"
// import {insertInStationyyyyFirst, insertInStationyyyyFirstNextStation,updateInStationyyyy,jobsAtStation} from "../Controllers/stationyyyyController.js"
import {insertInStationyyyyFirst, insertInStationyyyyFirstNextStation,updateInStationyyyy,jobsAtStation, countOfWorkAtStation,workAtStationInDay} from "../Controllers/stationyyyyController.js"
import {getOneWorkerStation, insertIntoStationAllocation} from "../Controllers/stationAllocationController.js"
const router = Router()

/**POST MEATHODS */
router.route("/ProductMasterInsert").post(insertInProductMaster)
router.route("/StationMasterInsert").post(insertIntoStationMaster)
router.route("/EmployeeMasterInsert").post(insertIntoEmployeeMaster)
router.route("/login").post(login)
router.route("/ProductyyyyInsert").post(insertInProductyyyy);
router.route("/StationyyyyInsertFirst").post(insertInStationyyyyFirst);
router.route("/StationyyyyInsertFirstNextStation").post(insertInStationyyyyFirstNextStation);
router.route("/StationAllocationInsert").post(insertIntoStationAllocation);
router.route("/StationyyyyShowJob").post(jobsAtStation);
router.route("/StationyyyyCountAtStation").post(countOfWorkAtStation);
router.route("/StationyyyyWorkInDay").post(workAtStationInDay);


/**GET MEATHODS */
router.route('/ProductMasterGet').get(getInfoFromProductMaster)
router.route('/ProductMasterGetOneProductAllParameters').get(getOneProductAllParametersInfoFromProductMaster)
router.route('/ProductMasterGetOneProductOneParameter').get(getOneProductOneParameterInfoFromProductMaster)
router.route("/StationMasterGet").get(getInfoFromStationMaster)
router.route('/ProductMasterGetProductNames').get(getProductNames)
router.route('/StationMasterGetOneStation').get(getOneStationFromStationMaster)
router.route('/StationMasterGetOneStationOneProduct').get(getOneStationOneProductFromStationMaster)
router.route('/EmployeeMasterGetNames').get(getNamesFromEmployeeMaster)
router.route('/EmployeeMasterGet').get(getAllFromEmployee)
router.route('/EmployeeMasterGetOne').get(getOneFromEmployee)
router.route('/getOneWorkerStation').get(getOneWorkerStation)


/**DELETE MEATHODS */
router.route('/ProductMasterDelete').delete(deleteFromProductMaster)
router.route('/StationMasterDelete').delete(deleteFromStationMaster)
router.route('/EmployeeMasterDelete').delete()

/**PUT MEATHOD */
router.route('/ProductMasterUpdate').put(updateProductMaster);
router.route('/StationMasterUpdate').put(updateStationMaster)
router.route('/EmployeeMasterUpdate').put(updateEmployee)
router.route('/Stationyyyyupdate').put(updateInStationyyyy)

export default router;