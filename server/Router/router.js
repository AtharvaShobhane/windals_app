import Router from "express"
import { insertInProductMaster, getInfoFromProductMaster, deleteFromProductMaster, updateProductMaster, getOneProductAllParametersInfoFromProductMaster, getOneProductOneParameterInfoFromProductMaster, getProductNames } from "../Controllers/productMasterController.js";
import {insertIntoStationMaster,deleteFromStationMaster,getInfoFromStationMaster,getOneStationFromStationMaster,getOneStationOneProductFromStationMaster,updateStationMaster} from "../Controllers/stationMasterController.js";
import {insertInProductyyyy} from "../Controllers/productyyyyController.js";
import {insertIntoEmployeeMaster,getAllFromEmployee,getOneFromEmployee,updateEmployee} from "../Controllers/employeeMasterController.js"
import {insertInStationyyyyFirst} from "../Controllers/stationyyyyController.js"
const router = Router()

/**POST MEATHODS */
router.route("/ProductMasterInsert").post(insertInProductMaster)
router.route("/StationMasterInsert").post(insertIntoStationMaster)
router.route("/EmployeeMasterInsert").post(insertIntoEmployeeMaster)
router.route("/ProductyyyyInsert").post(insertInProductyyyy);
router.route("/StationyyyyInsertFirst").post(insertInStationyyyyFirst);

/**GET MEATHODS */
router.route('/ProductMasterGet').get(getInfoFromProductMaster)
router.route('/ProductMasterGetOneProductAllParameters').get(getOneProductAllParametersInfoFromProductMaster)
router.route('/ProductMasterGetOneProductOneParameter').get(getOneProductOneParameterInfoFromProductMaster)
router.route("/StationMasterGet").get(getInfoFromStationMaster)
router.route('/ProductMasterGetProductNames').get(getProductNames)
router.route('StationMasterGetOneStation').get(getOneStationFromStationMaster)
router.route('StationMasterGetOneStationOneProduct').get(getOneStationOneProductFromStationMaster)
router.route('EmployeeMasterGet').get(getAllFromEmployee)
router.route('EmployeeMasterGetOne').get(getOneFromEmployee)

/**DELETE MEATHODS */
router.route('/ProductMasterDelete').delete(deleteFromProductMaster)
router.route('/StationMasterDelete').delete(deleteFromStationMaster)
router.route('/EmployeeMasterDelete').delete()

/**PUT MEATHOD */
router.route('/ProductMasterUpdate').put(updateProductMaster);
router.route('/StationMasterUpdate').put(updateStationMaster)
router.route('/EmployeeMasterUpdate').put(updateEmployee)

export default router;