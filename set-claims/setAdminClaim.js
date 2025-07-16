const admin = require('firebase-admin');
const serviceAccount = require('./serviceAccountKey.json'); // JSON ファイルのパス

admin.initializeApp({
  credential: admin.credential.cert(serviceAccount),
});

const uid = 'I2KlJMNcP0TVlWBex5Ahs3Pi9rm1';

admin.auth().setCustomUserClaims(uid, { role: 'admin' })
  .then(() => {
    console.log(`✅ Admin 権限を ${uid} に付与しました`);
    process.exit(0);
  })
  .catch((error) => {
    console.error('❌ エラー:', error);
    process.exit(1);
  });
