;#!/usr/bin/env bb

;; v1.0.1

;; Helper to switch SDK versions in IntelliJ IDEA and fvm

(ns runner
  (:require [clojure.java.shell :as shell]
            [clojure.string :refer [replace]]
            [clojure.java.io :refer [file]]
            [clojure.tools.cli :refer [parse-opts]]))

(def cli-options
  [["-h" "--help" "Show help"]])

;; TODO(lucky): need "version" validation
(defn change-idea-if-exists [version]
  (let [path    ".idea/libraries/Dart_SDK.xml"
        exists? (.exists (file path))]
    (if exists?
      ;; file exists, find current version
      (let [content         (slurp path)
            current-version (second
                             (first
                              (re-seq #"\<root url\=.*\/fvm\/versions\/(.*)\/bin.*\/>" content)))
            same?           (= current-version version)]
        (if same?
          (do
            (println (str "Current IDEA Flutter project is already on " version))
            ;; return success status
            false)
          (let [pattern     (re-pattern (replace current-version #"\." "\\\\."))
                new-content (replace content pattern version)]
            (spit path new-content)
            (println (str "Current IDEA Flutter project SDK is set to " version))
            ;; return success status
            true)))
      ;; file is not exists, print error
      (do
        (println ".idea SDK folder configuration is not found")

        ;; return success status
        false))))

;; TODO(lucky): need "version" validation
(defn change-fvm [version]
  (println (:out (shell/sh "fvm" "use" version)))
  (println (:out (shell/sh "fvm" "flutter" "pub" "get"))))

(defn change-sdk [{:keys [options arguments summary errors] :as args}]
  (when (change-idea-if-exists (first arguments))
    (change-fvm (first arguments))))

(let [{:keys [options arguments summary errors] :as args} (parse-opts *command-line-args* cli-options)
      is-args-empty?                                      (empty?
                                                           ;; to avoid NPE in babashka, bash will pass empty string to arguments
                                                           (filter #(not= % "") arguments))]
  (cond
    is-args-empty?  (println
                     (str "ERROR: Error changing sdk.\n\n" summary))
    errors          (println errors "\n" summary)
    (:help options) (println summary)
    arguments       (change-sdk args)))