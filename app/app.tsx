/* eslint-disable react-native/no-color-literals */
/* eslint-disable react-native/no-inline-styles */
import './i18n'
import './utils/ignore-warnings'
import { auth, firestore } from "./services/firebase"
import React from 'react'
import { Pressable, Text, TextInput, View } from 'react-native'
import { enableScreens } from 'react-native-screens'
import { GoogleSignin } from '@react-native-community/google-signin'
import { DateTime } from 'luxon'

GoogleSignin.configure({
  webClientId: '207758102756-9d2qj8fpthnmtiuubsitqclqhtmv3uhv.apps.googleusercontent.com',
})

async function onGoogleButtonPress() {
  // Get the users ID token
  const { idToken } = await GoogleSignin.signIn()

  // Create a Google credential with the token
  const googleCredential = auth.GoogleAuthProvider.credential(idToken)

  // Sign-in the user with the credential
  return auth().signInWithCredential(googleCredential)
}

enableScreens()

const blue = "blue"

function App() {
  const [amount, onChangeAmount] = React.useState('Dollar amount')
  // Set an initializing state whilst Firebase connects
  const [initializing, setInitializing] = React.useState(true)
  const [user, setUser] = React.useState()

  // Handle user state changes
  function onAuthStateChanged(user) {
    setUser(user)
    if (initializing) setInitializing(false)
  }

  React.useEffect(() => {
    const subscriber = auth().onAuthStateChanged(onAuthStateChanged)
    return subscriber
  }, [])

  const logout = () => {
    auth()
      .signOut()
      .then(() => console.log("User signed off"))
  }

  const addTransaction = ({ uid }) => () => {
    const trueAmount = Number(amount)
    console.log(trueAmount)
    if (!isNaN(trueAmount)) {
      console.log("add Transaction", uid)
      firestore()
        .collection('users')
        .doc(uid)
        .collection("transactions")
        .add({
          calenderId: DateTime.local().toISODate(),
          amount: 1000,
          date: DateTime.local().toISO()
        })
        .then(() => {
          console.log('Transaction added!')
        })
        .catch(err => {
          console.log(err)
        })
    } else {
      console.log("Fail")
    }
  }

  if (initializing) return null

  if (!user) {
    return (
      <View style={{ justifyContent: "center", alignItems: "center", height: "100%" }}>
        <View>
          <Text style={{ fontSize: 40, fontWeight: "700", textAlign: "center" }}>Epic Money</Text>
        </View>
        <Pressable style={{ marginTop: 18, padding: 18, borderRadius: 6, borderColor: "#21262d", borderWidth: 1 }}
          onPress={() => onGoogleButtonPress().then(() => console.log('Signed in with Google!'))}
        >
          <Text style={{ fontSize: 15, fontWeight: "600" }}>Login with Google</Text>
        </Pressable>
      </View>
    )
  } else {
    return (
      <View style={{ justifyContent: "center", alignItems: "center", height: "100%" }}>
        <Text style={{ fontSize: 24, fontWeight: "700", textAlign: "center" }}>Create Transaction</Text>
        <TextInput
          style={{ width: "60%", marginTop: 12, borderRadius: 6, paddingTop: 8, paddingBottom: 8, paddingLeft: 12, paddingRight: 12, height: 40, borderColor: 'gray', borderWidth: 1 }}
          onChangeText={string => onChangeAmount(string)}
          value={amount}
        />
        <Pressable style={{ marginTop: 18, padding: 18, borderRadius: 6, borderColor: "#21262d", borderWidth: 1 }} onPress={addTransaction(user)}>
          <Text style={{ fontSize: 15, fontWeight: "700" }}>Add Transaction</Text>
        </Pressable>
        <Pressable style={{ marginTop: 18, padding: 18, borderRadius: 6, borderColor: "#21262d", borderWidth: 1 }} onPress={logout}>
          <Text style={{ fontSize: 15, fontWeight: "600" }}>Logout</Text>
        </Pressable>
      </View>
    )
  }

}

export default App
