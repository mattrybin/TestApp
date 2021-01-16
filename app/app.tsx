import './i18n'
import './utils/ignore-warnings'

import React from 'react'
import { Pressable, Text, View } from 'react-native'
import { enableScreens } from 'react-native-screens'
import auth from '@react-native-firebase/auth'
import { GoogleSignin } from '@react-native-community/google-signin'

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

function App() {
  // Set an initializing state whilst Firebase connects
  const [initializing, setInitializing] = React.useState(true)
  const [user, setUser] = React.useState()

  // Handle user state changes
  function onAuthStateChanged(user) {
    setUser(user)
    if (initializing) setInitializing(false)
  }

  React.useEffect(() => {
    const subscriber = auth().onAuthStateChanged(onAuthStateChanged);
    return subscriber
  }, [])

  const logout = () => {
    auth()
      .signOut()
      .then(() => console.log("User signed off"))
  }

  if (initializing) return null

  if (!user) {
    return (
      <View>
        <Text>Login</Text>
        <Pressable
          onPress={() => onGoogleButtonPress().then(() => console.log('Signed in with Google!'))}
        >
          <Text>Google login</Text>
        </Pressable>
      </View>
    )
  }

  return (
    <View>
      <Text>Welcome {user ? user.email : "No user"}</Text>
      <Pressable onPress={logout}>
        <Text>Logout</Text>
      </Pressable>
    </View>
  )
}

export default App
