
const functions = require("firebase-functions/v1");
const { firestore } = require("firebase-admin");
const admin = require("firebase-admin");
admin.initializeApp();





exports.notificationSender = functions.runWith({ memory: '512MB' }).pubsub.schedule('* * * * *').onRun(async context => {


  let now = Date(Date.now());


  let split = now.split(' ');
  let timeSplit = split[4].split(":")

  let nowHours = timeSplit[0]-5;
  const nowMinutes = timeSplit[1];
  //appel de nowDay fait crash
  let nowDay = split[0]; // valeur textuelle for each weekday
  let timezone = ' AM'

  if(nowHours < 0){
      nowHours = 24 - nowHours;
  }
  
  if(nowHours >=12){
    nowHours = nowHours - 12;
    timezone = " PM";
  }

  if(nowDay == 'Mon'){
    nowDay = 0
  }
  else if(nowDay == 'Tue'){
    nowDay = 1
  }
  else if(nowDay == 'Wed'){
    nowDay = 2
  }
  else if(nowDay == 'Thu'){
    nowDay = 3
  }
  else if(nowDay == 'Fri'){
    nowDay = 4
  }
  else if(nowDay == 'Sat'){
    nowDay = 5
  }
  else if(nowDay == 'Sun'){
    nowDay = 6
  }

  const currentHour = nowHours.toString().concat(':').concat(nowMinutes.toString()).concat(timezone);

    const weeklyReminders = await firestore().collection('reminders').where('frequency', '==', 'ReminderType.weekly').where('hour', '==', currentHour).get()
// .where('weekday', '==', nowDay)
    notificationsToSend = [];

    weeklyReminders.forEach(async snapshot => {    
    const { date, frequency, hour, userId, weekday } = snapshot.data();

        // const queryTask = await firestore().collection('tasks').doc(userId).collection('mytasks').where(snapshot.id, '==', id);

        // queryTask.forEach(async snapshot =>{
        //   const{ createdAt, creatorId, dateTask, details, reminder, hourTask, tasktype, title} = snapshot.data()
        
          const notification = await admin.messaging().send({
            notification: {
                title: nowDay,
                body: 'Test',
            },
            data: {
              
              click_action: 'FLUTTER_NOTIFICATION_CLICK',
            },
            topic: userId
        })
        notificationsToSend.push(notification);
    })
   
    return notificationsToSend;
})