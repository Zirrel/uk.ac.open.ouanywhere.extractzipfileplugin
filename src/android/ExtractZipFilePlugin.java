package uk.ac.open.ouanywhere;

import android.os.Environment;
import java.io.BufferedInputStream;
import java.io.BufferedOutputStream;
import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.util.Enumeration;
import java.util.logging.Level;
import java.util.logging.Logger;
import java.util.zip.ZipEntry;
import java.util.zip.ZipException;
import java.util.zip.ZipFile;

import org.json.JSONArray;
import org.json.JSONException;

import org.apache.cordova.CallbackContext;
import org.apache.cordova.CordovaPlugin;
import org.apache.cordova.PluginResult;

public class ExtractZipFilePlugin extends CordovaPlugin
{
    public String packageName = "/Android/data/uk.ac.open.ouanywhere/";
    public String filename = "";
    public String importPath = ".import/";
    public Integer progressTotal = 0;
    public Integer progressExtracted = 0;
    public Integer progressPercent = 0;
    public CallbackContext callbackContext;
    
    @Override
    public boolean execute(String action, JSONArray args, CallbackContext callbackContext) throws JSONException
    {
        if (action.equals("unzipFile"))
        {
            this.callbackContext = callbackContext;
            this.filename = args.getString(0);
            cordova.getThreadPool().execute(new Runnable() {
                public void run() {
                    unzip();
                }
            });
            return true;
        }

        return false;
    }
    
    private void progress()
    {
        Integer tempPercent = (int)(((double)this.progressExtracted/(double)this.progressTotal)*100);
        if (tempPercent > this.progressPercent) {
            this.progressPercent = tempPercent;
            if (this.progressPercent < 100) {
                PluginResult progress = new PluginResult(PluginResult.Status.OK, this.progressPercent);
                progress.setKeepCallback(true);
                this.callbackContext.sendPluginResult(progress);
                
                try {
                    Thread.sleep(100);
                } catch (InterruptedException ex) {
                    Logger.getLogger(ExtractZipFilePlugin.class.getName()).log(Level.SEVERE, null, ex);
                }
            } else {
                File completedFile = new File(Environment.getExternalStorageDirectory().getPath() + this.packageName + this.filename + this.importPath + "importComplete");
                try {
                    completedFile.createNewFile();
                } catch (IOException e) {
                }
                this.callbackContext.success(this.progressPercent);
            }
        }
    }
    

    public void unzip()
    {
        boolean mExternalStorageAvailable = false;
        boolean mExternalStorageWriteable = false;
        String state = Environment.getExternalStorageState();

        if (Environment.MEDIA_MOUNTED.equals(state)) {
            // We can read and write the media
            mExternalStorageAvailable = mExternalStorageWriteable = true;
        } else if (Environment.MEDIA_MOUNTED_READ_ONLY.equals(state)) {
            // We can only read the media
            mExternalStorageAvailable = true;
            mExternalStorageWriteable = false;
        } else {
            // Something else is wrong. It may be one of many other states, but all we need
            //  to know is we can neither read nor write
            mExternalStorageAvailable = mExternalStorageWriteable = false;
        }
        
        if (!mExternalStorageAvailable || !mExternalStorageWriteable) {
            this.callbackContext.error("External Storage Not Found/Permission Denied");
            return;
        } else {
            File file = new File(Environment.getExternalStorageDirectory().getPath() + this.packageName + this.filename);
            String dirToInsert = Environment.getExternalStorageDirectory().getPath() + this.packageName + this.filename + this.importPath;
            File importDir = new File(dirToInsert);
            importDir.mkdirs();

            BufferedOutputStream dest = null;
            BufferedInputStream is = null;
            ZipEntry entry;
            ZipFile zipfile;

            try {
                zipfile = new ZipFile(file);
                this.progressTotal = zipfile.size();
                Enumeration<? extends ZipEntry> e = zipfile.entries();

                while (e.hasMoreElements()) {
                    this.progressExtracted++;
                    entry = (ZipEntry)e.nextElement();
                    is = new BufferedInputStream(zipfile.getInputStream(entry), 8192);
                    int count;
                    byte data[] = new byte[102222];
                    String fileName = dirToInsert + entry.getName();
                    File outFile = new File(fileName);

                    if (entry.isDirectory()) {
                        outFile.mkdirs();
                    } else {
                        FileOutputStream fos = new FileOutputStream(outFile);
                        dest = new BufferedOutputStream(fos, 102222);

                        while ((count = is.read(data, 0, 102222)) != -1)
                        {
                            dest.write(data, 0, count);
                        }

                        dest.flush();
                        dest.close();
                        is.close();
                    }
                    this.progress();
                }
            } catch (ZipException e1) {
                this.callbackContext.error(PluginResult.Status.MALFORMED_URL_EXCEPTION.toString());
                return;
            } catch (IOException e1) {
                this.callbackContext.error(e1.getMessage());
                return;
            }
        }
    }
}