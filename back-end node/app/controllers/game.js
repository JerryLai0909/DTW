

const qutil = require('../util/req_utils')
const { resUtil } = require('../util/res_utils')
const crypto = require('crypto');


exports.createGameInfoAndRecords = async (ctx, next) => {
    let reqBody = ctx.request.body
    console.log('reqBody:===>', reqBody)
    let game_creater_hash = reqBody.game_creater_hash

    let game_sensor_type = reqBody.sensor_type

    let game_title = Math.floor(Math.random() * 1000000) + 'JERRYGAME'
    let game_desc = 'DESC' + Math.floor(Math.random() * 1000000) + 'JERRYGAME'

    let axis = reqBody.axis_data
    let axs = axis.split(',')
    let minX = axs[0]
    let maxX = axs[1]
    let minY = axs[2]
    let maxY = axs[3]

    let data_type = reqBody.data_type
    let datas = reqBody.datas//这是一个数组数据，传感器一共有几组数据，就传几条，并且按照顺序

    let total_time = reqBody.total_time //x轴的时间，也是记录的时间
    let real_datas = datas.split('***')


    const inputString = game_sensor_type + data_type + axis + total_time + Math.floor(Math.random() * 1000000) + game_creater_hash;
    console.log('inputString : =>>>> : ', inputString)
    const hash = crypto.createHash('sha1');
    hash.update(inputString);
    let game_hash = hash.digest('hex').substring(0, 40);
    console.log('game_hash : =>>>> : ', game_hash)


    let insert_main_info = 'INSERT INTO game_main_info (game_hash, game_creater_hash, game_sensor_type, game_title, game_desc)' +
        'VALUES (:game_hash, :game_creater_hash, :game_sensor_type, :game_title, :game_desc)'

    let infos = await qutil.qinsert(insert_main_info, {
        game_hash: game_hash,
        game_creater_hash: game_creater_hash,
        game_sensor_type: game_sensor_type,
        game_title: game_title,
        game_desc: game_desc
    })


    let data_types_array = []
    switch (data_type) {
        case 1:
            data_types_array = [1, 0, 0]
            break
        case 2:
            data_types_array = [0, 1, 0]
            break
        case 3:
            data_types_array = [0, 0, 1]
            break
        case 4:
            data_types_array = [1, 1, 0]
            break
        case 5:
            data_types_array = [1, 0, 1]
            break
        case 6:
            data_types_array = [0, 1, 1]
            break
        case 7:
            data_types_array = [1, 1, 1]
            break
    }
    let result_record_ids = []

    for (let i = 0; i < real_datas.length; i++) {
        let insert_sql = 'INSERT INTO game_record_infos (game_hash, sensor_type, sensor_name, min_x,max_x,min_y,max_y, record_data, total_time, need_check) ' +
            'VALUES (:game_hash, :sensor_type, :sensor_name, :min_x, :max_x, :min_y, :max_y, :record_data, :total_time, :need_check)'
        let res = await qutil.qinsert(insert_sql, {
            game_hash: game_hash,
            game_creater_hash: game_creater_hash,
            sensor_type: game_sensor_type,
            sensor_name: 'ACCE',
            min_x: minX,
            max_x: maxX,
            min_y: minY,
            max_y: maxY,
            record_data: real_datas[i],
            total_time: total_time,
            need_check: data_types_array[i]
        })
        result_record_ids.push(res[0])
    }

    let result = {
        main_id: infos[0],
        result_record_ids: result_record_ids
    }
    resUtil(ctx, 200, result)
    //下面是具体的传感器信息，每一条都包含创建lineChart view的具体信息

}


/**
 * 直接包含所有数据，看一下能否绘制在首页。
 */
exports.getGameMainInfoList = async (ctx, next) => {
    //暂时不要条件
    let reqBody = ctx.request.body
    let sql = 'SELECT * FROM game_main_info WHERE 1 = 1 '
    let mains = await qutil.qselect(sql, {})
    console.log(mains)
    for (let i = 0; i < mains.length; i++) {
        let game_hash = mains[i].game_hash
        //查询record
        let record_sql = 'SELECT * FROM game_record_infos WHERE game_hash = :game_hash'
        let records = await qutil.qselect(record_sql, {
            game_hash: game_hash
        })
        mains[i].game_records = records

    }
    resUtil(ctx, 200, mains)
}