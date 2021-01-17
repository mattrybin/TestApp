import '@react-native-firebase/app'
import firestore from '@react-native-firebase/firestore'
import auth from '@react-native-firebase/auth'

firestore().settings({ host: 'http://localhost:8080', ssl: false, persistence: true, cacheSizeBytes: 10000000 })

export { auth, firestore }
