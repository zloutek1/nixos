# After a power cut: unlocking the Mac mini

The Mac mini starts by itself when the power comes back, but it waits for
its password before anything works, photos included. You can type it from
home.

1. Wait about **2 minutes** after the power returns.
2. Join the **home Wi-Fi** (this doesn't work from outside).
3. Connect from the laptop:
   ```sh
   ssh tomas@192.168.2.131
   ```
   If you're on the Kitty network, use `ssh tomas@192.168.1.131`. On the
   phone, Termius works the same way.
4. Type **tomas's password** when it asks. If the connection then drops,
   that's success: the Mac is unlocking.
5. Photos work again about **2 minutes** later. If not, message Tomas.

The password isn't written here. Keep it in your memory or your password
manager.
