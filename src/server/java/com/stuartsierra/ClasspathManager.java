package com.stuartsierra;

import java.lang.reflect.Method;
import java.net.URL;
import java.net.URLClassLoader;
import java.net.MalformedURLException;
import java.io.File;
import java.io.BufferedReader;
import java.io.FileReader;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;

import com.stuartsierra.cm.CompositeClassLoader;
import com.stuartsierra.cm.ClassLoaderCache;

public class ClasspathManager {

    private static final Class[] MAIN_METHOD_SIGNATURE = new Class[] { String[].class };

    private static final ClassLoaderCache cache;

    static {
	cache = new ClassLoaderCache();
    }

    private static List<URL> readClasspath() 
    {
        
	List<URL> urls = new ArrayList<URL>();
        try {
            URL url = new URL("file:/tmp");
            urls.add(url);
        } catch (MalformedURLException e) {
            System.out.println(e.toString());
        }
	return urls;
    }

    public static void sharedMain(String working_dir, String[] args) {

	final String mainClassName = args[0];
	final String[] mainArgs = Arrays.copyOfRange(args, 1, args.length);
	

	List<URL> urls = null;
        urls = readClasspath();

	final URL[] urlArray = urls.toArray(new URL[0]);

	Thread thread = new Thread() {
		public void run() {
		    List<ClassLoader> classloaders = new ArrayList<ClassLoader>();
		    for (int i = 0; i < urlArray.length; i++) {
			classloaders.add(cache.getClassLoader(urlArray[i]));
		    }
		    ClassLoader compositeLoader =
			new CompositeClassLoader(classloaders,
						 ClasspathManager.class.getClassLoader());
		    Thread.currentThread().setContextClassLoader(compositeLoader);
		    try {
			Class mainClass = compositeLoader.loadClass(mainClassName);
			Method mainMethod = mainClass.getMethod("main",
								MAIN_METHOD_SIGNATURE);
			mainMethod.invoke(null, (Object)mainArgs);
		    } catch (Exception e) {
			e.printStackTrace();
			System.exit(-1);
		    }	    
		}
	    };

	try {
	    thread.start();
	    thread.join();
	} catch (InterruptedException e) {
	    e.printStackTrace();
	    System.exit(-1);
	}
    }
    
    public static void main(String[] args) {
	sharedMain(System.getProperty("user.dir"), args);
    }

}
