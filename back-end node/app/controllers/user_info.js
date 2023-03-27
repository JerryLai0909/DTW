
const qutil = require('../util/req_utils')
const { resUtil } = require('../util/res_utils')


exports.getUserInfo = async (ctx, next) => {
    let reqBody = ctx.request.body
    let user_id = reqBody.user_id //change it to user_hash
    let sql = 'SELECT * FROM user_info WHERE id = :user_id'
    let users = await qutil.qselect(sql, {
        user_id: user_id
    })
    if (users.length === 0)
        return resUtil(ctx, 500, null)
    else
        return resUtil(ctx, 200, users[0])
}