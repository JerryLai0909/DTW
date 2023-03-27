const router = require('koa-router')();
const controller = require('../controllers');

router.get('/',)
router.get('welcome', async (ctx, next) => {
    ctx.body = 'Welcome the node.js'
});

let basePath = 'dtw/'
router.get(basePath + 'getMainInfoData', controller.base_info.getMainInfoData)
router.post(basePath + 'getMainInfoData', controller.base_info.getMainInfoData)

router.post(basePath + 'getUserInfo', controller.user_info.getUserInfo)

//game
router.post(basePath + 'createGameInfoAndRecords', controller.game.createGameInfoAndRecords)
router.post(basePath + 'getGameMainInfoList',controller.game.getGameMainInfoList)

module.exports = router;
