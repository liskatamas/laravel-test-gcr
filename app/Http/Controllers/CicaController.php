<?php

namespace App\Http\Controllers;

use Illuminate\Routing\Controller as BaseController;
use Illuminate\Support\Facades\DB;

class CicaController extends BaseController
{
    public function index()
    {
        try {
            echo "cica füle" . PHP_EOL;
            DB::connection()->getPdo();
        } catch (\Exception $e) {
            die("Could not connect to the database.  Please check your configuration. error:" . $e);
        }
        exit;
    }
}
